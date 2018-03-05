## APIキーの設定

```javascript
{
	API_TOKEN: 'YOUR_MIXPANEL_API_TOKEN',
	API_SECRET; 'YOUR_MIXPANEL_API_SECRET',

	// https://docs.google.com/spreadsheets/d/{ここの部分がスプレッドシートのkeyです}/edit#gid=0
	SPREAD_SHEET_KEY: 'YOUR_KEY'
}
```

## サービスアカウントの設定

cf. [https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-no-existing-users-service-account](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#on-behalf-of-no-existing-users-service-account)

## bundlerのインストール

```shell-script

cd path/to/directory
$ rbenv exec gem install bundler

```

## gemインストール

```shell
bundle install --path vendor/bundle
```

## 起動

```shell
ruby app.rb
```

## google_drive(gem)の操作

cf. [https://github.com/gimite/google-drive-ruby#example-to-readwrite-spreadsheets](https://github.com/gimite/google-drive-ruby#example-to-readwrite-spreadsheets)
