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

if l:channelID != "0"
  e ~/.SlackChannel.txt
  let outputfile = "$HOME/.SlackChannel.txt"
  execute ":redir!>".outputfile
    silent! call GetChannelHistory(l:channelID)
  redir END
  checktime
  execute ":normal G"
elseif l:channelID == "0"
  echo "Wrong Channel Name"
end
endfunction

function! GetChannelHistory(channelID)

ruby << RUBY
require 'http'
require 'time'
require 'json'

channelHistory = HTTP.post("https://slack.com/api/channels.history", params: {
  token: VIM.evaluate('g:slackToken'),
  channel: VIM.evaluate('a:channelID'),
  })

channelMessages = JSON.parse(channelHistory)

sleep 1

users = HTTP.post("https://slack.com/api/users.list", params: {
  token: VIM.evaluate('g:slackToken'),
  })

userData = JSON.parse(users)

channelMessages["messages"].reverse_each do |channelData|
  userData["members"].each do |i|
    if i["id"] == channelData["user"] then
      print i["profile"]["display_name"] + " " + (Time.at(channelData["ts"].to_i)).to_s
    end
  end
  print channelData["text"]
  print "\n"
  print "-------------------------------------"
  print "\n"
end
RUBY
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
