[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

# sarahck.vim

## Description
This plugin is does Slack with Vim.<br>

## Library
This plugin is using [vital.vim](https://github.com/vim-jp/vital.vim).<br>

## Install
If you using dein.vim.<br>
Please describe in your vimrc.<br>
```
call dein#add('higashi000/sarahck.vim')
```

If you using vim-plug.<br>
Please describe in your vimrc.<br>
```
Plug 'higashi000/sarahck.vim'
```

## How to use
Get your Slack legacy token, and please describe in vimscript file as follows<br>
Then load it with your vimrc.<br>
```
let g:slackToken = "Your Token"
```
Please don't publish this token.
If you publish this token, your account may be hijacked.

### Post
```
:SarahckPostMessage
```

### Display Channel List
Sorry, this function can only be used after Vim8.1.1594.
```
:SarahckChannelList
```

### Display Channel Message
```
:SarahckDispChannel channelName
```

### Channel Create
```
:SarahckCreateChannel channelName
```

### Add Reaction
※Sorry, this function can only be used after Vim8.1.1594.<br>
Please display channel message on popup window.<br>
After, you choose timestamp wanting to do add reaction.<br>
