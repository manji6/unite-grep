"=============================================================================
" FILE: grep.vim
" AUTHOR:  Tomohiro Nishimura <tomohiro68@gmail.com>
" Last Modified: 02 Dec 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
"
" Variables  "{{{
call unite#util#set_default('g:unite_source_grep_default_opts', '')
call unite#util#set_default('g:unite_source_grep_target_dir', '')
"}}}

function! unite#sources#grep#define() "{{{
  return s:grep_source
endfunction "}}}

let s:grep_source = {
  \   'name': 'grep',
  \   'is_volatile': 1,
  \   'required_pattern_length': 3,
  \ }

function! s:grep_source.gather_candidates(args, context) "{{{

  if len(a:args) == 0 && empty(g:unite_source_grep_target_dir)
    let g:unite_source_grep_target_dir = input('Target directory: ')
  endif

  let l:directory  = get(a:args, 0, g:unite_source_grep_target_dir)
  let l:extra_opts = get(a:args, 1, g:unite_source_grep_default_opts)

  if l:directory =~ '^-'
    let l:extra_opts = l:directory
    let l:directory  = g:unite_source_grep_target_dir
  endif

  let l:candidates = split(
    \ unite#util#system(printf(
    \   'grep %s %s %s',
    \   a:context.input,
    \   l:directory,
    \   l:extra_opts)),
    \  "\n")
  return map(l:candidates,
    \ '{
    \   "word": v:val,
    \   "source": "grep",
    \   "kind": "file",
    \   "action__path": substitute(v:val, "\:.*", "", ""),
    \ }')
endfunction "}}}

" vim: foldmethod=marker