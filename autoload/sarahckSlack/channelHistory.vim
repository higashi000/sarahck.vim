let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#channelHistory#Get(channelID, channelName)
  let messageData = {'data': [''], 'timestamp': [''], 'status': 'true'}
  let messageData.data = add(messageData.data, a:channelName)
  let messageData.timestamp = add(messageData.timestamp, '')
  let messageData.data = add(messageData.data, '')
  let messageData.timestamp = add(messageData.timestamp, '')
  let messageData.data = add(messageData.data, '-----------------------------------')
  let messageData.timestamp = add(messageData.timestamp, '')
  let messageData.data = add(messageData.data, '')
  let messageData.timestamp = add(messageData.timestamp, '')

  let l:channelID = sarahckSlack#channelExists#CheckTrueChannel(a:channelName)

  if l:channelID == '0'
    echo 'Wrong channel name'
    let messageData.status = 'false'
    return messageData
  endif

  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let historyAPI = 'https://slack.com/api/channels.history'
  let slackRes = s:H.get(historyAPI, {'token': g:slackToken, 'channel': l:channelID})

  let channelHistory = s:J.decode(slackRes.content)

  if channelHistory.ok == 0
    echo 'error'
    return [-1]
  endif

  let slackRes = s:H.get('https://slack.com/api/users.list', {'token' : g:slackToken})
  let users = s:J.decode(slackRes.content)
  if channelHistory.ok == 0
    echo 'error'
    return [-1]
  endif

  for channelData in channelHistory.messages
    let l:dictKeys = keys(channelData)

    let l:checkEmoji = v:false

    for i in l:dictKeys
      if i == 'reactions'
        let l:checkEmoji = v:true
        break
      endif
    endfor
    for user in users.members
      if user.id == channelData.user
        if user.profile.display_name == ''
          let messageData.data = add(messageData.data, user.profile.real_name)
          let messageData.timestamp = add(messageData.timestamp, channelData.ts)
        else
          let messageData.data = add(messageData.data, user.profile.display_name)
          let messageData.timestamp = add(messageData.timestamp, channelData.ts)
        endif
        let messageData.data = add(messageData.data, '')
        let messageData.timestamp = add(messageData.timestamp, channelData.ts)
        let commandStr = 'date --date "@' . channelData.ts . '"'
        let sendTime = system(commandStr)
        let parseSendTime = split(sendTime, '\n')
        let messageData.data = add(messageData.data, parseSendTime[0])
        let messageData.timestamp = add(messageData.timestamp, channelData.ts)
        let messageData.data = add(messageData.data, '')
        let messageData.timestamp = add(messageData.timestamp, channelData.ts)

        let textData = split(channelData.text, '\n')
        for i in textData
          let messageData.data = add(messageData.data, i)
          let messageData.timestamp = add(messageData.timestamp, channelData.ts)
        endfor

        let messageData.data = add(messageData.data, '')
        let messageData.timestamp = add(messageData.timestamp, channelData.ts)

        if l:checkEmoji == v:true
          let messageData.data = add(messageData.data, '↓reaction↓')
          let messageData.timestamp = add(messageData.timestamp, channelData.ts)
          for reaction in channelData.reactions
            let messageData.data = add(messageData.data, ':'.reaction.name.':')
            let messageData.timestamp = add(messageData.timestamp, channelData.ts)
          endfor
        endif
        let messageData.data = add(messageData.data, '-----------------------------------')
        let messageData.timestamp = add(messageData.timestamp, '')
      endif
    endfor
  endfor

  return messageData
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
