let s:save_cpo = &cpo
set cpo&vim

function! sarahckDisplay#dmHistory#display(channel)
  let messageData = sarahckSlack#dm#history(a:channel)

  echo messageData.id

  let ctx = {
        \ 'idx': 0,
        \ 'timestamp': messageData.timestamp,
        \ 'id': messageData.id,
        \ }

  if has('patch-8.1.1594')
    call popup_menu(messageData.data, {
        \ 'maxheight': 50,
        \ 'moved': 'any',
        \ 'filter': function('sarahckDisplay#dmHistory#selectReaction', [ctx])
        \ })
  endif
endfunction

function! sarahckDisplay#dmHistory#selectReaction(ctx, id, key) abort
  if a:key ==# 'j'
    if a:ctx.idx < len(a:ctx.timestamp) - 1
      let a:ctx.idx = a:ctx.idx + 1
      echo a:ctx.idx
    endif
  elseif a:key ==# 'k'
    if a:ctx.idx > 0
      let a:ctx.idx = a:ctx.idx - 1
      echo a:ctx.idx
    endif
  elseif a:key ==# "\<cr>"
    call sarahckSlack#addReaction#dmReaction(a:ctx.timestamp[a:ctx.idx], a:ctx.id)
  endif

  return popup_filter_menu(a:id, a:key)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
