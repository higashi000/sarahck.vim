let s:save_cpo = &cpo
set cpo&vim

" メッセージ送信
function! sarahck#SendMessage(...)
let l:argumentList = a:000

let l:channelID = CheckTrueChannel(l:argumentList[0])
let l:postResult = ""

if l:channelID != "0"
python3 << PYTOHN3
import vim
import requests
import json

sendData = {
    "token" : vim.eval("g:slackToken"),
    "channel" : vim.eval("l:channelID"),
    "text" : vim.eval("l:argumentList[1]"),
}

slackRes = requests.get("https://slack.com/api/chat.postMessage", params = sendData).json()

if slackRes["ok"] == True:
    print("Complete")
else :
    print("Failure")
PYTOHN3
elseif l:channelID == "0"
    echo "Wrong Channel Name"
endif
endfunction

function! sarahck#DispChannelHistory(channelName)
let l:channelID = CheckTrueChannel(a:channelName)

let l:fileName = "$HOME/." . a:channelName . ".txt"
echo l:fileName

if l:channelID != "0"
  let outputfile = l:fileName
  execute ":redir!>".outputfile
    silent! call GetChannelHistory(l:channelID)
  redir END
  execute ":e" . l:fileName
  execute ":normal G"
elseif l:channelID == "0"
  echo "Wrong Channel Name"
endif
endfunction

function! GetChannelHistory(channelID)

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

for channelData in reversed(channelHistory["messages"]) :
    for i in users["members"] :
        if i["id"] == channelData["user"] :
            if i["profile"]["display_name"] != "" :
                print(i["profile"]["display_name"] + " " + str((datetime.fromtimestamp(float(channelData["ts"])))))
            else :
                print(i["profile"]["real_name"] + " " + str((datetime.fromtimestamp(float(channelData["ts"])))))
    print(channelData["text"])
    print("")
    print("-------------------------------------")
    print("")
PYTHON3

endfunction

function! sarahck#DispChannelList()
  let l:channelList = GetChannelList()
  if has('patch-8.1.1594')
    let pos = getpos('.')
    " let channelWindow = popup_create(l:channelList, {
    "         \ 'pos': 'topleft',
    "         \ 'line': line('.') + 2,
    "         \ 'col': col('.') + 2,
    "         \ 'moved': 'any',
    "         \ })
    call popup_menu(l:channelList, {
            \ 'pos' : 'topleft',
            \ 'line' : line('.') + 2,
            \ 'col' : col('.') + 2,
            \ 'moved' : 'any',
            \ 'filter' : 'popup_filter_menu',
            \ })
  else
    echo "未実装〜"
  endif
endfunction

function! GetChannelList()
let l:channelList = []
python3 << PYTHON3
import vim
import requests
import json

sendData = {
    "token" : vim.eval('g:slackToken')
}

slackRes = requests.get('https://slack.com/api/channels.list', params = sendData).json()
if slackRes["ok"] == True :
    for i in slackRes["channels"] :
        vim.command(":call add(l:channelList, '"+i["name"]+"')")
else :
    print("failed to get channel list")
PYTHON3

return l:channelList
endfunction

" チャンネルリスト取得
function! CheckTrueChannel(channelName)
  let l:channelID = 0

python3 << PYTHON3
import vim
import requests
import json

sendData = {
    "token" : vim.eval('g:slackToken')
}

slackRes = requests.get('https://slack.com/api/channels.list', params = sendData).json()

if slackRes["ok"] == True :
    for i in slackRes["channels"] :
        if i["name"] == vim.eval('a:channelName'):
            vim.command(":let l:channelID = '"+i["id"]+"'")
else :
    print("failed to get channel list")
PYTHON3

return l:channelID
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
