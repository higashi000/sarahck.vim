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

" if has('patch-8.1.1594')
"   call popup_menu(l:channelHistory, {
"       \ 'pos' : 'topleft',
"       \ 'line' : line('.') + 2,
"       \ 'col' : col('.') + 2,
"       \ 'moved' : 'any',
"       \ 'filter' : 'popup_filter_menu',
"       \ })
" else
  let l:fileName = "$HOME/." . a:channelName . ".txt"
  echo l:fileName

  if l:channelID != "0"
    let outputfile = l:fileName
    execute ":redir!>".outputfile
      let l:i = len(l:channelHistory) - 1
      while i >= 0
          silent echo l:channelHistory[i]
          let l:i = l:i - 1
      endwhile
    redir END
    execute ":e" . l:fileName
    execute ":normal G"
  elseif l:channelID == "0"
    echo "Wrong Channel Name"
  endif
" endif
endfunction
"}}}

" チャンネルのメッセージ取得 ---{{{
function! GetChannelHistory(channelID)

let l:channelMessages = []

python3 << PYTHON3
import requests
import vim
import json
import time
from datetime import datetime

sendData = {
    "token" : vim.eval('g:slackToken'),
    "channel" : vim.eval('a:channelID'),
}

channelHistory = requests.get("https://slack.com/api/channels.history", params = sendData).json()

time.sleep(1)


sendData = {
    "token" : vim.eval('g:slackToken'),
}
users = requests.get("https://slack.com/api/users.list", params = sendData).json()

for channelData in channelHistory["messages"] :
    for i in users["members"] :
        if i["id"] == channelData["user"] :
            messageData = (i['profile']['display_name'] if i['profile']['display_name'] != '' else i['profile']['real_name']) + ' ' + str((datetime.fromtimestamp(float(channelData["ts"]))))
            messageData += '\n\n'
            messageData += channelData['text']
            messageData += '\n'
            messageData += '-------------------------------------'
            messageData += '\n'
            vim.command(":call add(l:channelMessages, '"+messageData+"')")
PYTHON3

return l:channelMessages
endfunction
"}}}

" チャンネル一覧の表示--- {{{
let g:channelsName = []
let g:channelsID = []
let g:isFirstReq = 0
function! sarahck#DispChannelList()
  if !g:isFirstReq
    call GetChannelList()
    let g:isFirstReq = 1
  endif

  if has('patch-8.1.1594')
    let pos = getpos('.')
    call popup_menu(g:channelsName, {
            \ 'pos' : 'topleft',
            \ 'line' : line('.') + 2,
            \ 'col' : col('.') + 2,
            \ 'moved' : 'any',
            \ 'filter' : 'popup_filter_menu',
            \ 'callback' : function('SelectChannel', [g:channelsName])
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
function! GetChannelList()
let l:channelList = []
python3 << PYTHON3
import vim
import requests
import json

sendData = {
    "token" : vim.eval('g:slackToken')
}

slackRes = requests.get('https://slack.com/api/users.conversations', params = sendData).json()
if slackRes["ok"] == True :
    for i in slackRes["channels"] :
        vim.command(":call add(g:channelsName, '"+i["name"]+"')")
        vim.command(":call add(g:channelsID, '"+i["id"]+"')")
else :
    print("failed to get channel list")
PYTHON3

return l:channelList
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
