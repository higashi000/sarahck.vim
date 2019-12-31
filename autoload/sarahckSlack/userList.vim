let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#userList#getUserList(name, id)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let url = 'https://slack.com/api/users.list'

  let slackRes = s:H.get(url, {'token': g:slackToken})

  let res = s:J.decode(slackRes.content)

  if res.ok == 1
    for i in res.members
      let profile = i.profile
      if profile.display_name != ''
        call add(a:name, profile.display_name)
      else
        call add(a:name, profile.real_name)
      endif
      call add(a:id, i.id)
    endfor
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
