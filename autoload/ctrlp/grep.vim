if exists('g:loaded_ctrlp_grep') && g:loaded_ctrlp_grep
  finish
endif
let g:loaded_ctrlp_grep = 1

let s:V = vital#of('ctrlp_grep')
let s:Prelude = s:V.import('Prelude')
let s:DataString = s:V.import('Data.String')
let s:Process = s:V.import('Process')

let s:grep_var = {
\ 'init'   : 'ctrlp#grep#init()',
\ 'exit'   : 'ctrlp#grep#exit()',
\ 'accept' : 'ctrlp#grep#accept',
\ 'lname'  : 'grep',
\ 'sname'  : 'grep',
\ 'type'   : 'path',
\ 'nolim'  : 1,
\ 'opmul'  : 1,
\ 'sort'   : 0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:grep_var)
else
  let g:ctrlp_ext_vars = [s:grep_var]
endif

let g:ctrlp_grep_max_candidates = get(g:, 'ctrlp_grep_max_candidates', 0)
let g:ctrlp_grep_lazy_update = get(g:, 'ctrlp_grep_lazy_update', 500)
let g:ctrlp_grep_min_chars = get(g:, 'ctrlp_grep_min_chars', 1)
let g:ctrlp_grep_reverse_candidates = get(g:, 'ctrlp_grep_reverse_candidates', 0)

" quoted from [unite-grep](https://github.com/ujihisa/unite-grep)
" If the grep command is linux version, use -e option which means fetching
" only existing files.
function! s:is_linux()
  " Linux version only has -V option
  call s:Process.system('grep -V')
  return !s:Process.get_last_status()
endfunction

function! s:generate_grep_command(input_query, ...)
  let cmd = ''
  let query = a:input_query
  let limit_num_result = g:ctrlp_grep_max_candidates!=0

  if has_key(g:, 'ctrlp_grep_command_definition')
    let cmd = g:ctrlp_grep_command_definition
  else
    if executable('ag')
      let cmd = "ag --vimgrep --ignore tags '{query}' " . (limit_num_result? ' --max-count {max_candidates}' : '')
    else
      let cmd = "grep . '{query}'"
  endif

  let query = s:DataString.replace(a:input_query," ", ".*")
  let cmd = s:DataString.replace(cmd,'{query}', query)
  let cmd = s:DataString.replace(cmd,'{max_candidates}', g:ctrlp_grep_max_candidates)
  return cmd
endfunction

function! ctrlp#grep#start()
  let s:old_matcher = get(g:, 'ctrlp_match_func', 0)
  let g:ctrlp_match_func = {'match': 'ctrlp#grep#matcher'}
  let s:old_lazy_update = get(g:, 'ctrlp_lazy_update', 0) 
  let s:old_key_loop = get(g:, 'ctrlp_key_loop', 0) 
  if g:ctrlp_grep_lazy_update == 0
    echom "[Warn]ctrlp-grep: Do not set g:ctrlp_grep_lazy_update to 0!"
    let g:ctrlp_grep_lazy_update = 1
  endif
  let g:ctrlp_lazy_update = g:ctrlp_grep_lazy_update
  let g:ctrlp_key_loop = 0
  call ctrlp#init(ctrlp#grep#id())
endfunction

function! ctrlp#grep#init(...)
  return []
endfunction

function! ctrlp#grep#matcher(items, input, limit, mmode, ispath, crfile, regex)
  if len(a:input) <= g:ctrlp_grep_min_chars
    return []
  endif
  let cmd = s:generate_grep_command(a:input, a:regex)
  let results = split(s:Process.system(cmd),"\n")
  if g:ctrlp_grep_reverse_candidates == 1
    let results = reverse(results)
  endif
  return results
endfunction

function! ctrlp#grep#accept(mode, str)
  call ctrlp#exit()
  let res = split(a:str, ':')
  let filename = res[0]
  let numline = res[1]
  call ctrlp#acceptfile(a:mode, filename)
  exe 'normal! ' . numline . 'G'
endfunction

function! ctrlp#grep#exit()
  call s:revert_settings()
endfunction

function! s:revert_settings()
  if type(s:old_matcher) == 0
    unlet! g:ctrlp_match_func
  else
    let g:ctrlp_match_func = s:old_matcher
  endif
  let g:ctrlp_lazy_update = s:old_lazy_update
  let g:ctrlp_key_loop = s:old_key_loop
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#grep#id()
  return s:id
endfunction
