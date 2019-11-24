if exists('g:loaded_sarahck')
  finish
endif
let g:loaded_sarahck = 1


let s:save_cpo = &cpo
set cpo&vim

command! SarahckPostMessage call sarahckSlack#postMsg#SendMessage()
command! -nargs=1 SarahckDispChannel call sarahckDisplay#channelHistory#DispChannelHistory(<f-args>)
command! SarahckChannelList call sarahckDisplay#channelList#DispChannelList()
command! -nargs=1 SarahckCreateChannel call sarahckSlack#createChannel#ChannelCreate(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
