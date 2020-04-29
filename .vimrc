syntax on
set number
set mouse=a
set updatetime=1000
set tabstop=4
set numberwidth=3

" Easier split movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" These are plugin related
set signcolumn=yes
let g:airline_powerline_fonts=1
let g:gitgutter_highlight_linenrs = 1
let g:airline#extensions#ale#enabled = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_fmt_command = "goimports"
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_fields = 1 
let g:go_highlight_format_strings = 1
let g:airline#extensions#tabline#enabled = 1

" Colors
highlight Pmenu ctermbg=black ctermfg=darkblue
highlight PmenuSel ctermbg=black ctermfg=lightblue
highlight LineNr ctermfg=darkgrey
highlight SignColumn ctermfg=darkgrey
highlight DiffAdd ctermfg=darkgreen
highlight DiffChange ctermfg=darkblue
highlight DiffDelete ctermfg=darkred
highlight ALEWarningSign ctermbg=black ctermfg=brown
highlight ALEErrorSign ctermbg=black ctermfg=red
highlight GoParamName ctermfg=darkgreen
highlight GoParamType ctermfg=blue
highlight VertSplit ctermfg=black ctermbg=darkgreen
highlight Constant ctermfg=darkgreen 
highlight ALEError ctermbg=brown
highlight Error ctermbg=brown
highlight ErrorMsg ctermbg=brown
highlight SpellBad ctermbg=brown
highlight SpellRare ctermbg=brown

" Show where 80 char line is
highlight ColorColumn ctermbg=darkgray
set colorcolumn=99

" Tab Completion
map <S-Tab> <C-N>

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" Just a default thing, optional
Plug 'junegunn/vim-easy-align'

" Adds git change tracking (lines)
Plug 'airblade/vim-gitgutter'

" The go-to Go plugin
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Indent guides
" Plug 'nathanaelkane/vim-indent-guides'

" Linting
Plug 'w0rp/ale'

" NerdTree stuff
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Theming
" https://vimawesome.com/plugin/vim-airline-superman
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" NerdTree Config
"let NERDTreeStatusline=-1
let NERDTreeMinimalUI=1
autocmd vimenter * NERDTree | wincmd p
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
