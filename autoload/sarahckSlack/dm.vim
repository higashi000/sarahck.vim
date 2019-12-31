let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#dm#dmList(dmName, dmID)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let imListURL = 'https://slack.com/api/im.list'

  let slackRes = s:H.post(imListURL, {'token': g:slackToken})

  let res = s:J.decode(slackRes.content)

  if res.ok != 1
    echo 'failure'
  endif

  let name = []
  let id = []

  call sarahckSlack#userList#getUserList(name, id)

  for i in res.ims
    call add(a:dmID, i.id)

    let cnt = 0

    for userID in id
      if userID == i.user
        call add(a:dmName, name[cnt])
      endif
      let cnt = cnt + 1
    endfor
  endfor
endfunction

function! sarahckSlack#dm#sendDM(dmID)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let postdmURL = 'https://slack.com/api/chat.postMessage'

  let sendText = input('send Text >> ')

  let slackRes = s:H.post(postdmURL, {
      \ 'token': g:slackToken,
      \ 'channel': a:dmID,
      \ 'text': sendText,
      \ 'as_user': 'true',
      \ })

  let res = s:J.decode(slackRes.content)

  if res.ok == 1
    echo 'complete'
  else
    echo 'failure'
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
