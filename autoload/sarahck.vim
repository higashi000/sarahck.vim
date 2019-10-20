let s:save_cpo = &cpo
set cpo&vim

" メッセージ送信 ---{{{
function! sarahck#SendMessage(...)
let l:argumentList = a:000

let l:channelID = CheckTrueChannel(l:argumentList[0])
let l:postResult = ''

if l:channelID != '0'
  let url = 'https://slack.com/api/chat.postMessage'
  let sendText = l:argumentList[1]
  let channel = l:channelID

  let slackRes = webapi#http#post(url,
          \ {'token': g:slackToken,
          \ 'text': sendText,
          \ 'channel': channel,
          \ 'as_user': 'true'})

  let res = webapi#json#decode(slackRes.content)
  if res.ok == 1
    echo 'complete'
  else
    echo 'failure'
  endif
elseif l:channelID == '0'
    echo 'Wrong Channel Name'
endif
endfunction
"}}}

"チャンネルのメッセージを表示---{{{
function! sarahck#DispChannelHistory(channelName)
let l:channelID = CheckTrueChannel(a:channelName)
let l:channelHistory = GetChannelHistory(l:channelID)

if has('patch-8.1.1594')
  call popup_menu(l:channelHistory, {
      \ 'maxheight' : 50,
      \ 'moved' : 'any',
      \ 'filter' : 'popup_filter_menu',
      \ })
else
  let l:fileName = "$HOME/." . a:channelName . ".txt"
  echo l:fileName

  if l:channelID != "0"
    let outputfile = l:fileName
    execute ":redir!>".outputfile
      for i in l:channelHistory
          silent echo i
      endfor
    redir END
    execute ":e" . l:fileName
  elseif l:channelID == "0"
    echo "Wrong Channel Name"
  endif
endif
endfunction
"}}}

" チャンネルのメッセージ取得 ---{{{
function! GetChannelHistory(channelID)
let messageData = []

let url = 'https://slack.com/api/channels.history'

let slackRes = webapi#http#post(url,
        \ {'token' : g:slackToken,
        \ 'channel' : a:channelID})
let channelHistory = webapi#json#decode(slackRes.content)

let url = 'https://slack.com/api/users.list'
let slackRes = webapi#http#post(url, {'token' : g:slackToken})
let users = webapi#json#decode(slackRes.content)

for channelData in channelHistory.messages
  for user in users.members
    if user.id == channelData.user
      if user.profile.display_name == ''
        let messageData = add(messageData, user.profile.real_name)
      else
        let messageData = add(messageData, user.profile.display_name)
      endif
      let messageData = add(messageData, '')
      let messageData = add(messageData, channelData.text)
      let messageData = add(messageData, '')
      let messageData = add(messageData, '-----------------------------------')
    endif
  endfor
endfor

return messageData
endfunction
"}}}

" チャンネル一覧の表示--- {{{
function! sarahck#DispChannelList()
  let l:channelsName = []
  let l:channelsID = []
  call GetChannelList(l:channelsName, l:channelsID)

  if has('patch-8.1.1594')
    let pos = getpos('.')
    call popup_menu(l:channelsName, {
            \ 'line' : line('.') + 2,
            \ 'col' : col('.') + 2,
            \ 'moved' : 'any',
            \ 'filter' : 'popup_filter_menu',
            \ 'callback' : function('SelectChannel', [l:channelsName])
            \ })
  else
    echo "未実装〜"
  endif
endfunction

function! SelectChannel(ctx, id, idx) abort
  if a:idx ==# -1
    return
  endif

  call sarahck#DispChannelHistory(a:ctx[a:idx-1])
endfunction
"}}}

" チャンネルリストの取得 {{{
function! GetChannelList(channelsName, channelsID)
  let url = 'https://slack.com/api/users.conversations'
  let slackRes = webapi#http#post(url, {'token': g:slackToken})
  let res = webapi#json#decode(slackRes.content)
  if res.ok == 1
    for i in res.channels
      call add(a:channelsName, i.name)
      call add(a:channelsID, i.id)
    endfor
  else
    echo 'Failed to get channel list'
  endif
endfunction
" }}}

" チャンネルが存在するか -- {{{
function! CheckTrueChannel(channelName)
  let l:channelID = 0

  let url = 'https://slack.com/api/channels.list'

  let slackRes = webapi#http#post(url, {'token': g:slackToken})
  let res = webapi#json#decode(slackRes.content)
  if res.ok == 1
    for i in res.channels
      if a:channelName == i.name
        let l:channelID = i.id
      endif
    endfor
  else
    echo 'Failed to get channel list'
  endif

return l:channelID
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
