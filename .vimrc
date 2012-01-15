set nocompatible
set runtimepath+=/home/scriper/.vim/bundle/vam
let g:vim_addon_manager = {}
let g:vim_addon_manager.plugin_sources = {}
let g:vim_addon_manager.plugin_sources['haml'] = {'type' : 'git', 'url' : 'git://github.com/tpope/vim-haml.git' }
let g:vim_addon_manager.plugin_sources['cucumber'] = {'type' : 'git', 'url' : 'git://github.com/tpope/vim-cucumber.git' }
call vam#ActivateAddons(["vim-ruby","SuperTab","clang_complete","Command-T","rails","snipmate","snipmate-snippets","ZenCoding",
      \ "vim-coffee-script","node.js","Gist","syntastic2","VikiDeplate","TailMinusF","haml", "cucumber",
      \ "rtorrent_syntax_file", "The_NERD_tree"]) 
filetype plugin on
filetype plugin indent on
set autoindent
set smartindent
set expandtab "вставлять пробелы, а не табы
set softtabstop=4 "величина отступа
set shiftwidth=2
set smarttab
set nowrap
set foldmethod=marker
set ignorecase 
set smartcase 
set incsearch
set hlsearch
set wildmenu
set wildignore=*.swp,*.pyc,*.bak
set wcm=<Tab> 
set showmatch
" show number of lines in visual
set showcmd
" Automatically cd into the directory that the file is in. It breaks Command-T
" facility
"set autochdir 
" Automatically read files which have been changed outside of Vim, if we
" haven't changed it already.
set autoread
set hidden
command -bar -nargs=1 OpenURL :silent !firefox <args>
let g:rails_ctags_arguments='--languages=-javascript'
let g:rails_default_file='config/database.yml'
autocmd VimLeavePre * silent mksession! ~/.vim/lastSession.vim "Save session before leaving editor
autocmd BufReadPost /tmp/mutt-* sil %s/^\(>\s*\)\+$//e "Don't quote blank lines in mail
" viki configuration:{{{
autocmd BufRead,BufNewFile *.viki set ft=viki
let g:vikiNameSuffix=".viki"
let g:vikiOpenFileWith_html  = "silent !firefox %{FILE}"
let g:vikiOpenFileWith_pdf  = "silent !zathura %{FILE}"
let g:vikiOpenUrlWith_mailto = 'urxvtc -e mutt %{URL}'
let g:vikiOpenUrlWith_ANY    = "silent !firefox %{URL}"
" }}}
" Say where to store backup and  swap files{{{
set backup
set backupdir=~/.vimbk
set backupdir+=.,/tmp
set directory=~/.vimbk
set directory+=.,/tmp
"}}}
"Configure Syntactic syntax checker:{{{
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['ruby', 'php'],
                           \ 'passive_filetypes': ['puppet'] }
"}}}
"Encoding menu:{{{
menu Encoding.koi8-r :e ++enc=8bit-koi8-r<CR>
menu Encoding.windows-1251 :e ++enc=8bit-cp1251<CR>
menu Encoding.ibm-866 :e ++enc=8bit-ibm866<CR>
menu Encoding.utf-8 :e ++enc=2byte-utf-8 <CR>
menu Encoding.ucs-2le :e ++enc=ucs-2le<CR>
"}}}
"Spelling options,menu,bindings:{{{
let spell_executable = "aspell"
let spell_language_list = "ru,en"
let spell_auto_type = "txt,mail,text,none"
let spell_guess_language_ft = "txt,mail,text"
menu VVspell.enable_ru          :setlocal spell spelllang=ru<CR>
menu VVspell.enable_en          :setlocal spell spelllang=en<CR>
menu VVspell.enable_enru        :setlocal spell spelllang=en,ru<CR>
nmap \sr :setlocal spell spelllang=ru<CR>
nmap \se :setlocal spell spelllang=en<CR>
"}}}
"SuperTab key bindings, completion type{{{
let g:SuperTabDefaultCompletionType = "context" 
let g:SuperTabMappingForward = '<C-Space>'
let g:SuperTabMappingBackward = '<s-c-space>'
imap <C-@> <C-Space> 
"}}}
"Manage my gists:{{{
let g:gist_clip_command = 'xclip -selection clipboard' "copy the gist code with option -c
let g:gist_open_browser_after_post = 1 " I want to open browser after the post 
let g:gist_browser_command = 'firefox %URL%' " i'm using firefox atm :3
let g:gist_show_privates = 1 " I want to see my private gists with Gist -l
"}}}
" General key bindings:{{{
nnoremap ; :
nnoremap , ;
imap ii <C-[>
" Sudo to write
cmap w!! w !sudo tee % >/dev/null
set pastetoggle=<F5>
nnoremap <space> za
imap <F1> <Esc>:set<Space>nu!<CR>a
nmap <F1> :set<Space>nu!<CR>
imap <F2> <Esc>:w<CR>a
nmap <F2> :w<CR>
" Exit Vim, unless there are some buffers which have been changed, use bmod to
" go to the next modified buffer
nmap <F12> :qa<CR>
imap <F12> <Esc>:qa<CR>
" tab navigation
nmap <C-t> :tabnew<CR>
imap <C-t> <Esc>:tabnew<CR>
map <leader>r :call WinTranslate(expand('<cword>'))<cr>
"}}}
" Status Line: {{{
"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning = '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction


"statusline setup
set statusline=%f "tail of the filename

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator

function! SlSpace()
    if exists("*GetSpaceMovement")
        return "[" . GetSpaceMovement() . "]"
    else
        return ""
    endif
endfunc
set statusline+=%{SlSpace()}

set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file
set laststatus=2
"}}}
set cul "highlight the cursor line
set background=dark
set t_Co=256
colorscheme molokai2
" Gui options: {{{
if has('gui_running')
  if has('unix')
    set guifont=Ubuntu\ Mono\ 14
  elseif has('win32') || has('win64')
    set guifont=Consolas:h12
  endif
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
endif
" }}}
if has('mouse')
  set mouse=a "enable mouse support in console
endif
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
