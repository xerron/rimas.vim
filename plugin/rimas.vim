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
function! s:Lookup(type, ...)
  " comandline
  let l:cmdline = ''
  if exists('g:rimas_merimas_path')
    if (a:0 == 1)
      let l:cmdline = 'java -jar '. g:rimas_merimas_path . 'merimas.jar ' . '-t '. a:type . ' -w ' . a:1 
    elseif (a:0 == 2)
      let l:arg2 = ''
      if a:1 == 'v' || a:1 == 'vocal' || a:1 == 'c' || a:1 == 'consonante' || a:1 == 'i' || a:1 == 'indiferente'
        let l:arg2 = ' -s ' . a:1         
      elseif a:1 == '-1' || a:1 == '2' || a:1 == '3' || a:1 == '4' || a:1 == '5' || a:1 == '6' || a:1 == '7' || a:1 == '8' || a:1 == '9' || a:1 == '10'
        let l:arg2 = ' -n ' . a:1         
      endif
      let l:cmdline = 'java -jar '. g:rimas_merimas_path . 'merimas.jar ' . '-t '. a:type . l:arg2 . ' -w '. a:2 
    elseif (a:0 == 3)
      let l:cmdline = 'java -jar '. g:rimas_merimas_path . 'merimas.jar ' . '-t '. a:type . ' -s ' . a:1 . ' -n '. a:2 . ' -w '. a:3 
    else
      echom 'Demasiados parametros'
    endif
  else
    echom 'No se encuentra el path a merimas.jar (g:rimas_merimas_path)'
  endif
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
  let expl = ''
  if l:cmdline == ''
    let expl=''
  else
    let expl=system(l:cmdline)
  endif
  put =expl
  1d
  normal! Vgqgg
  " no redimencionar ventana.
  " exec 'resize ' . (line('$')+1)
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
  nnoremap <unique> <LocalLeader>R :RimasAsonantesCurrentWord<CR>
endif

command! RimasCurrentWord :call <SID>Lookup('c', expand('<cword>'))
command! RimasAsonantesCurrentWord :call <SID>Lookup('a', expand('<cword>'))
command! RimasOptions :call <SID>ChangeOptions()
command! -nargs=+ Rima :call <SID>Lookup('c', <f-args>)
command! -nargs=+ RimaAsonante :call <SID>Lookup('a', <f-args>)

let &cpo = s:save_cpo


