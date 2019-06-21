# sarahck.vim

## Description
このプラグインはVimでSlackをすることを目標に作成されたものです

## Install
このプラグインを使用するにはvimがruby拡張に対応している必要があります

### dein
```
[[plugins]]
repo = 'higashi000/sarahck.vim'
```

## How to use
Slackのトークンを取得し，そのトークンを以下のようにvimscriptファイルに記述後 
`source $FILEPATH/SlackAPI.vim`等でvimrcに記述して読み込ませてください<br>
※このトークンを他人に知られてしまうと乗っ取られてしまうので他人に教えないでください

```
let g:slackToken = "Your Token"
```

### 投稿
```
:SarahckPostMessage 'channel名' '投稿したいテキスト'
```

スペース等を挟む場合はスペースの前に`\`を記述する必要があります

### チャンネルのメッセージ確認
```
:SarahckDispChannel 'channel名'
```
