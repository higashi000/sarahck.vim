# sarahck.vim

## Description
このプラグインはVimでSlackをすることを目標に作成されたものです

## Install
以下のコマンドを実行してpython3が有効化されているかを確認してください．<br>
されていない場合は有効化を行ってください．
```
:echo has('python3')
```

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
