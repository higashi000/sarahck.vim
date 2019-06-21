let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* SarahckPostMessage call sarahck#SendMessage(<f-args>)
command! -nargs=1 SarahckDispChannel call sarahck#DispChannelHistory(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
