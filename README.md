# sarahck.vim

## Description
このプラグインはVimでSlackをすることを目標に作成されたものです

## 動作確認済み環境
Ubuntu18.04<br>
Windows10<br>

## Library
このプラグインでは内部で[webapi-vim](https://github.com/mattn/webapi-vim)を使用しています．<br>
インストールをお願いします．<br>

## Install
deinを使用している際にはvimrcに以下を記述してください
```
call dein#add('higashi000/sarahck.vim')
```

## How to use
Slackのレガシートークンを取得し，そのトークンを以下のようにvimscriptファイルに記述後，
`source $FILEPATH/SlackAPI.vim`をvimrcに記述して読み込ませてください<br>
※このトークンを他人に知られてしまうとアカウントが乗っ取られてしまうので他人に教えないでください
```
let g:slackToken = "Your Token"
```

### 投稿
```
:SarahckPostMessage 'channel名' '投稿したいテキスト'
```

スペース等を挟む場合はスペースの前に`\`を記述する必要があります

### チャンネル一覧の表示
この機能はVim8.1.1594以降でないと使用できません.
Vim8.1.1594より古いバージョン，Neovimへの対応は検討していますが，ある程度ほかの機能を実装し終えてからになると思います.
```
:SarahckChannelList
```

### チャンネルのメッセージ確認
```
:SarahckDispChannel 'channel名'
```
