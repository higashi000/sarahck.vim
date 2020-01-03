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

### Check Direct Message
※Sorry, this function can only be used after Vim8.1.1594.<br>

```
:SarahckDM
```

### Pictures
- channel list

![channellist](https://user-images.githubusercontent.com/34534343/71722277-a1412180-2e6b-11ea-8cc4-a37df66df603.png)

- DM List

![dmlist](https://user-images.githubusercontent.com/34534343/71722316-c0d84a00-2e6b-11ea-9bec-d0befceaa87f.png)

- choice check history or send message

![dmchoice](https://user-images.githubusercontent.com/34534343/71722327-cdf53900-2e6b-11ea-840f-be8d37f57d96.png)

- DM History and Channel History

![dmhistory](https://user-images.githubusercontent.com/34534343/71722350-dd748200-2e6b-11ea-9a6e-28723e44cfd6.png)
