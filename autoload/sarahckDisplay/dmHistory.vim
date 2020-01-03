let s:save_cpo = &cpo
set cpo&vim

function! sarahckDisplay#dmHistory#display(channel)
  let messageData = sarahckSlack#dm#history(a:channel)

  if has('patch-8.1.1594')
    call popup_menu(messageData.data, {
        \ 'maxheight': 50,
        \ 'moved': 'any',
        \ 'filter': 'popup_filter_menu',
        \ })
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
