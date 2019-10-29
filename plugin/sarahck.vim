if exists('g:loaded_sarahck')
  finish
endif
let g:loaded_sarahck = 1


let s:save_cpo = &cpo
set cpo&vim

command! SarahckPostMessage call sarahck#SendMessage()
command! SarahckDispChannel call sarahck#DispChannelHistory()
command! SarahckChannelList call sarahck#DispChannelList()
command! -nargs=1 SarahckCreateChannel call sarahck#ChannelCreate(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
