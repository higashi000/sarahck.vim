let s:save_cpo = &cpo
set cpo&vim

" メッセージ送信
function! sarahck#SendMessage(...)
  let l:argumentList = a:000

  let l:channelID = CheckTrueChannel(l:argumentList[0])
  let l:postResult = ""

  if l:channelID != "0"
ruby << RUBY
  require 'http'
  require 'json'

  response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
    token: VIM.evaluate('g:slackToken'),
    channel: VIM.evaluate('l:channelID'),
    text: VIM.evaluate('l:argumentList[1]'),
    })

  res = JSON.parse(response)
  if res["ok"] == true then
    print("Complete")
  else
    print("Failure")
  end
RUBY
elseif l:channelID == "0"
echo "Wrong Channel Name"
endif
endfunction


" チャンネルリスト取得
function! CheckTrueChannel(channelName)
  let l:channelID = 0

ruby << RUBY
  require 'http'
  require 'json'

  response = HTTP.post("https://slack.com/api/channels.list", params: {
    token: VIM.evaluate('g:slackToken'),
    })

  res = JSON.parse(response)

  if res["ok"] == true then
    res["channels"].each do |i|
      if i["name"] == VIM.evaluate('a:channelName') then
        VIM.command(%Q[let l:channelID = "#{i["id"]}"])
      end
    end
  else
    print("failed to get channel list")
  end
RUBY

return l:channelID
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
