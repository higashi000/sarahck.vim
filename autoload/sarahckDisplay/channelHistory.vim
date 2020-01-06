let s:save_cpo = &cpo
set cpo&vim

function! sarahckDisplay#channelHistory#DispChannelHistory(channelName)
  let l:channelID = sarahckSlack#channelExists#CheckTrueChannel(a:channelName)
  let l:channelHistory = sarahckSlack#channelHistory#Get(l:channelID, a:channelName)

  if l:channelHistory.status == 'false'
    echo 'error'
    return
  endif

  if l:channelID == '0'
    echo 'Wrong ChannelName'
    return
  endif

  let ctx = {
        \ 'idx': 0,
        \ 'timestamp': l:channelHistory.timestamp,
        \ 'id': l:channelID,
        \ }

  if has('patch-8.1.1594')
    call popup_menu(l:channelHistory.data, {
        \ 'maxheight' : 50,
        \ 'moved' : 'any',
        \ 'filter': function('sarahckDisplay#dmHistory#selectReaction', [ctx])
        \ })
  elseif has('nvim')
    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, l:channelHistory)
    let opts = {'relative': 'cursor',
              \ 'width': 40,
              \ 'height': 50,
              \ 'col': 0,
              \ 'row': 5,
              \ 'anchor': 'NW',
              \ 'style': 'minimal'}

    let win = nvim_open_win(buf, 0, opts)

    call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
  else
    let l:fileName = "$HOME/." . a:channelName . ".txt"
    echo l:fileName

    let outputfile = l:fileName
    execute ":redir!>".outputfile
      for i in l:channelHistory
          silent echo i
      endfor
    redir END
    execute ":e" . l:fileName
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
