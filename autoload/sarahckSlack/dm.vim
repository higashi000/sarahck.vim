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

function! sarahckSlack#dm#history(channel)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let url = 'https://slack.com/api/im.history'

  let slackRes = s:H.get(url, {'token': g:slackToken, 'channel': a:channel})

  let res = s:J.decode(slackRes.content)

  if res.ok != 1
    return -1
  endif

  let messageData = ['-----------------------------------', '']

  let user1 = {'id': '', 'name': ''}
  let user2 = {'id': '', 'name': ''}

  for i in res.messages
    if i.user == user1.id
      let mesageData = add(messageData, user1.name)
    elseif i.user == user2.id
      let mesageData = add(messageData, user2.name)
    else
      if user1.id == ''
        let user1.id = i.user
        let user1.name = sarahckSlack#user#getUserName(i.user)
        let mesageData = add(messageData, user1.name)
      else
        let user2.id = i.user
        let user2.name = sarahckSlack#user#getUserName(i.user)
        let mesageData = add(messageData, user2.name)
      endif
    endif

    let commandStr = 'date --date "@' . i.ts . '"'
    let messageData = add(messageData, system(commandStr))
    let messageData = add(messageData, '')

    let textStr = i.text
    let textData = split(textStr, '\n')
    echo 'a'
    for i in textData
      let messageData = add(messageData, i)
    endfor

    let messageData = add(messageData, '')
  endfor

  return messageData
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
