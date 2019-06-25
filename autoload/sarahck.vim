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
e ~/.SlackChannel.txt

if l:channelID != "0"
  let outputfile = "$HOME/.SlackChannel.txt"
  execute ":redir!>".outputfile
    silent! call GetChannelHistory(l:channelID)
  redir END
  checktime
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
            print(i["profile"]["display_name"] + " " + str((datetime.fromtimestamp(float(channelData["ts"])))))
    print(channelData["text"])
    print("")
    print("-------------------------------------")
    print("")
PYTHON3

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
