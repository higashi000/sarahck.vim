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

  let messageData = {'data': [''], 'timestamp': [''], 'id': a:channel}

  let user1 = {'id': '', 'name': ''}
  let user2 = {'id': '', 'name': ''}

  for i in res.messages
    if i.user == user1.id
      let messageData.data = add(messageData.data, user1.name)
      let messageData.timestamp = add(messageData.timestamp, i.ts)
    elseif i.user == user2.id
      let messageData.data = add(messageData.data, user2.name)
      let messageData.timestamp = add(messageData.timestamp, i.ts)
    else
      if user1.id == ''
        let user1.id = i.user
        let user1.name = sarahckSlack#user#getUserName(i.user)
        let messageData.data = add(messageData.data, user1.name)
        let messageData.timestamp = add(messageData.timestamp, i.ts)
      else
        let user2.id = i.user
        let user2.name = sarahckSlack#user#getUserName(i.user)
        let messageData.data = add(messageData.data, user2.name)
        let messageData.timestamp = add(messageData.timestamp, i.ts)
      endif
    endif

    let commandStr = 'date --date "@' . i.ts . '"'
    let sendTime = system(commandStr)
    let parseSendTime = split(sendTime, '\n')
    let messageData.data = add(messageData.data, parseSendTime[0])
    let messageData.timestamp = add(messageData.timestamp, i.ts)

    let messageData.data = add(messageData.data, '')
    let messageData.timestamp = add(messageData.timestamp, i.ts)

    let textData = split(i.text, '\n')
    for j in textData
      let messageData.data = add(messageData.data, j)
      let messageData.timestamp = add(messageData.timestamp, i.ts)
    endfor

    let messageData.data = add(messageData.data, '')
    let messageData.timestamp = add(messageData.timestamp, '')

    let messageData.data = add(messageData.data, ['-----------------------------------'])
    let messageData.timestamp = add(messageData.timestamp, '')
  endfor

  return messageData
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
