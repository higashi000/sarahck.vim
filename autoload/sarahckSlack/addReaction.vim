let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#addReaction#Choice(ctx, id, idx) abort
  if a:idx ==# -1
    return
  endif

  let pattern = '\v\d{10,}\v\.\v\d{6,}'
  if match(a:ctx[a:idx-1], pattern) == 0
    call sarahckSlack#addReaction#AddReaction(a:ctx[a:idx-1], a:ctx[0])
  endif
endfunction

function! sarahckSlack#addReaction#dmReaction(timeStamp, id)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let l:name = input('Emoji Name :')
  let url = 'https://slack.com/api/reactions.add'

  let slackRes = s:H.post(url,
        \ {'token': g:slackToken,
        \  'channel': a:id,
        \  'name': l:name,
        \  'timestamp': a:timeStamp})
  echo ' '
  let res = s:J.decode(slackRes.content)
  if res.ok == 1
    echo 'complete'
  else
    echo 'failure'
  endif
endfunction


function! sarahckSlack#addReaction#AddReaction(timeStamp, channelName)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let l:name = input('Emoji Name :')

  let l:channelID = sarahckSlack#channelExists#CheckTrueChannel(a:channelName)

  if l:channelID != '0'
    let url = 'https://slack.com/api/reactions.add'

    let slackRes = s:H.post(url,
          \ {'token': g:slackToken,
          \  'channel': l:channelID,
          \  'name': l:name,
          \  'timestamp': a:timeStamp})
    echo ' '
    let res = s:J.decode(slackRes.content)
    if res.ok == 1
      echo 'complete'
    else
      echo 'failure'
    endif
  else
    echo 'Wrong Channel Name'
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
