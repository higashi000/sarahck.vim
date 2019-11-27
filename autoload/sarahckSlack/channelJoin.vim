let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#channelJoin#Join()
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let channelName = input('channel name :')
  echo ' '
  let channelID = sarahckSlack#channelExists#CheckTrueChannel(channelName)

  if channelID == '0'
    echo 'Wrong Channel Name'
    return
  endif

  let url = 'https://slack.com/api/channels.join'

  let slackRes = s:H.post(url, {'token': g:slackToken, 'name': channelName, })
  let res = s:J.decode(slackRes.content)

  if res.ok == 1
    echo 'complete'
  else
    echo 'failure'
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
