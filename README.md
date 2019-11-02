# sarahck.vim

## Description
This plugin is does Slack with Vim.<br>

## Done operation check
Ubuntu18.04<br>
manjaro<br>
Windows10<br>

## Library
This plugin is using [webapi-vim](https://github.com/mattn/webapi-vim).<br>
Please install before this plugin using.<br>

## Install
If you using dein.vim.<br>
Please describe in your vimrc.<br>
```
call dein#add('higashi000/sarahck.vim')
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
