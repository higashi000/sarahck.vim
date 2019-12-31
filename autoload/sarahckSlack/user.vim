let s:save_cpo = &cpo
set cpo&vim

function! sarahckSlack#user#getUserName(id)
  let s:V = vital#sarahck#new()
  let s:H = s:V.import('Web.HTTP')
  let s:J = s:V.import('Web.JSON')

  let url = 'https://slack.com/api/users.list'

  let slackRes = s:H.get(url, {'token': g:slackToken})

  let res = s:J.decode(slackRes.content)

  if res.ok != 1
    return -1
  endif

  for i in res.members
    if i.id == a:id
      let profile = i.profile
      if profile.display_name != ''
        return profile.display_name
      else
        return profile.real_name
      endif
    endif
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
