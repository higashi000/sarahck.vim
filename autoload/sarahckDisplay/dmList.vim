let s:save_cpo = &cpo
set cpo&vim

function! sarahckDisplay#dmList#dispDM()
  let dmName = []
  let dmID = []
  call sarahckSlack#dm#dmList(dmName, dmID)

  let ctx = {
    \ 'idx': 0,
    \ 'dmName': dmName,
    \ 'dmID': dmID
    \ }

  if has('patch-8.1.1594')
    call popup_menu(dmName, {
        \ 'maxheight' : 50,
        \ 'filter' : function('sarahckDisplay#dmList#selectDM', [ctx])
        \ })
  endif
endfunction

function! sarahckDisplay#dmList#selectDM(ctx, id, key) abort
  if a:key ==# 'j'
    if a:ctx.idx < len(a:ctx.dmName) - 1
      let a:ctx.idx = a:ctx.idx + 1
    endif
  elseif a:key ==# 'k'
    if a:ctx.idx > 0
      let a:ctx.idx = a:ctx.idx - 1
    endif
  elseif a:key ==# "\<cr>"
    let choice = input('Check DM History / Send Message (h/s) >> ')

    if choice == 'h'
      call sarahckDisplay#dmHistory#display(a:ctx.dmID[a:ctx.idx])
    elseif choice == 's'
      call sarahckSlack#dm#sendDM(a:ctx.dmID[a:ctx.idx])
    else
      echo 'Please correct choice.'
    endif
  endif

  return popup_filter_menu(a:id, a:key)
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
