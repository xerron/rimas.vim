" rimas.vim - Acceso rapido a los diccionarios de rimas
" Version: 1.0
" Maintainer: E. Manuel Cerrón Angeles <xerron.angels@gmail.com>
" Date: 2015-02-04
" Licence: MIT

if exists("g:loaded_rimas")
  finish
endif

let g:loaded_rimas=1

let s:save_cpo = &cpo
set cpo&vim

let s:path = expand("<sfile>:p:h")

if !exists("g:rimas_keep_focus")
  let g:rimas_keep_focus=1
endif

" Posición del split
" '', 'rightbelow', 'vertical', 'vertical rightbelow'
if !exists("g:rimas_window_position")
	let g:rimas_window_position='vertical rightbelow'
endif

" Devuelve la ultima ventana rimas
function! s:FindLastWindow()
  if exists('g:rimas_window')
    return bufwinnr(g:rimas_window)
  endif
  return -1
endfunction

" Imprimir resultado de busqueda
function! s:Lookup(word)
  let winnr = s:FindLastWindow()
	let cur_winnr = winnr()
  if winnr >= 0
    execute winnr . 'wincmd w'
  else
    " Abre un buffer llamado rimas
    silent keepalt vertical belowright 35 split rimas
    let g:rimas_window = bufnr('%')
  endif
  setlocal noswapfile nobuflisted nospell wrap modifiable
  setlocal buftype=nofile bufhidden=hide
  1,$d
  " verifico si esta definido un path
  if exists("g:rimas_merimas_path")
    let expl=system('java -jar ' . g:rimas_merimas_path . 'merimas.jar -w ' . a:word)
  put =expl
  else
    let expl='No se encuentra merimas.jar, porfavor defina el path. (g:rimas_merimas_path)'
  put =expl
  endif
  1d
  normal! Vgqgg
  exec 'resize ' . (line('$')+1)
  setlocal nonumber nomodifiable filetype=rimas
  nnoremap <silent> <buffer> q :q<CR>
  " Volver a la ventana actual.
  if g:rimas_keep_focus > 0
    execute cur_winnr . 'wincmd w'
  endif
endfunction

" Cambiar opciones por defecto
function! s:ChangeOptions()
  echo 'aun no implementado'
endfunction

if !exists('g:rimas_map_keys')
  let g:rimas_map_keys=1
endif

if g:rimas_map_keys
  nnoremap <unique> <LocalLeader>r :RimasCurrentWord<CR>
endif

command! RimasCurrentWord :call <SID>Lookup(expand('<cword>'))
command! RimasOptions :call <SID>ChangeOptions()
command! -nargs=1 Rima :call <SID>Lookup(<f-args>)

let &cpo = s:save_cpo


