let s:save_cpo = &cpo
set cpo&vim

" メッセージ送信 ---{{{
function! sarahck#SendMessage()

let l:channelName = input('Post Channel :')
let l:text = input('Post Message :')

let l:channelID = CheckTrueChannel(l:channelName)
let l:postResult = ''

if l:channelID != '0'
  let url = 'https://slack.com/api/chat.postMessage'

  let slackRes = webapi#http#post(url,
          \ {'token': g:slackToken,
          \ 'text': l:text,
          \ 'channel': l:channelID,
          \ 'as_user': 'true'})

  echo ' '
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
let l:channelHistory = GetChannelHistory(l:channelID, a:channelName)

if has('patch-8.1.1594')
  call popup_menu(l:channelHistory, {
      \ 'maxheight' : 50,
      \ 'moved' : 'any',
      \ 'filter' : 'popup_filter_menu',
      \ 'callback' : function('sarahck#Choice', [l:channelHistory])
      \ })
elseif has('nvim')
  let buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(buf, 0, -1, v:true, l:channelHistory)
  let opts = {'relative': 'cursor',
            \ 'width': 40,
            \ 'height': 50,
            \ 'col': 0,
            \ 'row': 5,
            \ 'anchor': 'NW',
            \ 'style': 'minimal'}

  let win = nvim_open_win(buf, 0, opts)

  call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')

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
function! GetChannelHistory(channelID, channelName)
let messageData = [a:channelName, '', '-----------------------------------', '']

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
      let messageData = add(messageData, channelData.ts)
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

" チャンネルの作成 --- {{{
function! sarahck#ChannelCreate(name)
  let l:url = 'https://slack.com/api/channels.create'
  let slackRes = webapi#http#post(url,
      \ {'token' : g:slackToken,
      \ 'name': a:name})

  let res = webapi#json#decode(slackRes.content)
  if res.ok == 1
    echo 'complete'
  else
    echo 'failure'
  endif
endfunction
"  "}}}

" リアクション--- {{{
function! sarahck#Choice(ctx, id, idx) abort
  if a:idx ==# -1
    return
  endif

  let pattern = '\v\d{10,}\v\.\v\d{6,}'
  if match(a:ctx[a:idx-1], pattern) == 0
    call sarahck#AddReaction(a:ctx[a:idx-1], a:ctx[0])
  endif
endfunction

function! sarahck#AddReaction(timeStamp, channelName)
  let l:name = input('Emoji Name :')

  let l:channelID = CheckTrueChannel(a:channelName)

  if l:channelID != '0'
    let url = 'https://slack.com/api/reactions.add'

    let slackRes = webapi#http#post(url,
        \ {'token': g:slackToken,
        \  'channel': l:channelID,
        \  'name': l:name,
        \  'timestamp': a:timeStamp})
    echo ' '
    let res = webapi#json#decode(slackRes.content)
    if res.ok == 1
      echo 'complete'
    else
      echo 'failure'
    endif
  else
    echo 'Wrong Channel Name'
  endif
endfunction
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
