let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#channelExists#CheckTrueChannel(channelName)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let l:channelID = 0

  let url = 'https://slack.com/api/channels.list'

  let slackRes = s:H.get(url, {'token': g:slackToken})
  let res = s:J.decode(slackRes.content)

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

let &cpo = s:save_cpo
unlet s:save_cpo
