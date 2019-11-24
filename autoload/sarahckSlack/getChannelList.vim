let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#getChannelList#GetChannelList(channelsName, channelsID)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let url = 'https://slack.com/api/users.conversations'
  let slackRes = s:H.get(url, {'token': g:slackToken})
  let res = s:J.decode(slackRes.content)
  if res.ok == 1
    for i in res.channels
      call add(a:channelsName, i.name)
      call add(a:channelsID, i.id)
    endfor
  else
    echo 'Failed to get channel list'
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
