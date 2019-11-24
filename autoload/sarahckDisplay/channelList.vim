let s:save_cpo = &cpo
set cpo&vim

function! sarahckDisplay#channelList#DispChannelList()
  let l:channelsName = []
  let l:channelsID = []
  call sarahckSlack#getChannelList#GetChannelList(l:channelsName, l:channelsID)

  if has('patch-8.1.1594')
    let pos = getpos('.')
    call popup_menu(l:channelsName, {
            \ 'line' : line('.') + 2,
            \ 'col' : col('.') + 2,
            \ 'moved' : 'any',
            \ 'filter' : 'popup_filter_menu',
            \ 'callback' : function('sarahckDisplay#channelList#SelectChannel', [l:channelsName])
            \ })
  else
    echo "未実装〜"
  endif
endfunction

function! sarahckDisplay#channelList#SelectChannel(ctx, id, idx) abort
  if a:idx ==# -1
    return
  endif

  call sarahckDisplay#channelHistory#DispChannelHistory(a:ctx[a:idx-1])
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
