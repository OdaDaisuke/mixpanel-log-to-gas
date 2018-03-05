require 'bundler/setup'
require "google_drive"
require 'net/http'
require 'uri'
require 'json'
require 'date'

API_TOKEN = ""
API_SECRET = ""
SPREAD_SHEET_KEY = ''

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
session =  GoogleDrive::Session.from_service_account_key("service_account_config.json")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
ws = session.spreadsheet_by_key(SPREAD_SHEET_KEY).worksheets[0]

def getMixPanelInfo(demension, params)
  baseURI = "https://mixpanel.com/api/2.0/"

  uri = URI.parse(baseURI + demension + "/")
  request = Net::HTTP::Post.new(uri)
  request.basic_auth(API_SECRET, "")
  request.body = params

  req_options = { use_ssl: uri.scheme == "https" }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  	http.request(request)
  end

  return response.body
end

# mixpanelInfo = getMixPanelInfo("segmentation", "from_date=2018-03-02&to_date=2018-03-05&event=your_event")
# baseURI = "https://mixpanel.com/api/2.0/"
#
# uri = URI.parse(baseURI + "segmentation/")
# request = Net::HTTP::Post.new(uri)
# request.basic_auth(API_SECRET, "")
# request.body = "from_date=2018-03-02&to_date=2018-03-05&event=visit"
#
# req_options = { use_ssl: uri.scheme == "https" }
# request.each do |name, val|
#   p name + ":" + val
# end

today = Date.today
yesterday = today - 1
pageview = getMixPanelInfo("segmentation", "from_date=#{yesterday}&to_date=#{today}&event=visit")
cvClicked = getMixPanelInfo("segmentation", "from_date=#{yesterday}&to_date=#{today}&event=cvClick")
mixpanelVal = {
  visit: JSON.parse(pageview),
  cvClick: JSON.parse(cvClicked)
}

# ws[y軸セル, x軸セル]
# 日付 = ws[>=3, 1]
# Page view = ws[=>3, 2]
# CV click = ws[=>3], 2]

for n in 3...10 do
  if ws[n, 1] == '' && ws[n+1,1] == ''
    ws[n, 1] = Date.today()
    ws[n, 2] = mixpanelVal[:visit]['data']['values']['visit'][yesterday.to_s]
    ws[n, 3] = mixpanelVal[:cvClick]['data']['values']['cvClick'][yesterday.to_s]
    break;
  end
end

ws.save

def dumpallCells(ws)
  # Dumps all cells.
  (1..ws.num_rows).each do |row|
    (1..ws.num_cols).each do |col|
      p ws[row, col]
    end
  end
end

# dumpallCells(ws)

# Yet another way to do so.
# p ws.rows

# Reloads the worksheet to get changes by other clients.
ws.reload
