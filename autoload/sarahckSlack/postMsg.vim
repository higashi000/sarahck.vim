let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#postMsg#SendMessage()
  let l:channelName = input('Post Channel :')
  let l:text = input('Post Message :')

  let l:channelID = sarahckSlack#channelExists#CheckTrueChannel(l:channelName)

  if l:channelID == '0'
    echo 'wrong channel name'
    return
  endif

  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let slackRes = s:H.post('https://slack.com/api/chat.postMessage',
     \ {'token' : g:slackToken,
     \ 'channel' : l:channelID,
     \ 'text': l:text,
     \ 'as_user' : 'true'})
  let res = s:J.decode(slackRes.content)

  echo ' '

  if res.ok == 1
    echo 'comlete'
  else
    echo 'failure'
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
