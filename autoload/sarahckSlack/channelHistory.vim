let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#channelHistory#Get(channelID, channelName)
  let messageData = [a:channelName, '', '-----------------------------------', '']

  let l:channelID = sarahckSlack#channelExists#CheckTrueChannel(a:channelName)

  if l:channelID == '0'
    echo 'Wrong channel name'
    return [-1]
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
          let messageData = add(messageData, user.profile.real_name)
        else
          let messageData = add(messageData, user.profile.display_name)
        endif
        let messageData = add(messageData, '')
        let messageData = add(messageData, channelData.ts)
        let messageData = add(messageData, '')
        let messageData = add(messageData, channelData.text)
        let messageData = add(messageData, '')

        if l:checkEmoji == v:true
          let messageData = add(messageData, '↓reaction↓')
          for reaction in channelData.reactions
            let messageData = add(messageData, ':'.reaction.name.':')
          endfor
        endif
        let messageData = add(messageData, '-----------------------------------')
      endif
    endfor
  endfor

  return messageData
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
