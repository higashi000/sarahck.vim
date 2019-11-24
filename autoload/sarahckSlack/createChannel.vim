let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#createChannel#ChannelCreate(name)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let l:url = 'https://slack.com/api/channels.create'

  let slackRes = s:H.post(url,
      \ {'token' : g:slackToken,
      \ 'name': a:name})

  let res = s:J.decode(slackRes.content)

  if res.ok == 1
    echo 'complete'
  else
    echo 'failure'
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
