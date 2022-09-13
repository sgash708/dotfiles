syntax on

if &compatible
  set nocompatible
endif

set rtp+=/opt/homebrew/bin/fzf
set nu
set hlsearch
set showmatch
set nobackup
set noswapfile
set ignorecase
set nocursorline
set nocursorcolumn
set list
set listchars=space:_,tab:».,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set clipboard+=unnamed
set foldmethod=marker
set foldlevel=1
set foldcolumn=0
set mouse=a

let NERDTreeShowHidden = 1
let mapleader = "\<Space>"
let g:python_host_prog = system('echo -n $(which python2)')
let g:python3_host_prog = system('echo -n $(which python3)')

nmap <silent> <Leader>D :LspDefinition<CR>
nmap <silent> <f2> :LspRename<CR>
nmap <silent> <Leader>T :LspTypeDefinition<CR>
nmap <silent> <Leader>R :LspReferences<CR>
nmap <silent> <Leader>I :LspImplementation<CR>
nmap <silent> <Leader>g :Rg<CR>

nnoremap <Esc><Esc> :noh<CR>
nnoremap <silent><C-n> :NERDTreeToggle<CR>
filetype plugin indent on

" :Tでターミナル起動
:tnoremap <Esc> <C-\><C-n>
autocmd TermOpen * startinsert
command! -nargs=* T split | wincmd j | resize 20 | terminal <args>

" commentary
autocmd FileType go setlocal commentstring=//\ %s
autocmd FileType go set ts=4 sw=4 noet
autocmd FileType html set sw=2 ts=2 et
autocmd FileType javascript set sw=2 ts=2 et
autocmd FileType typescript setlocal sts=2 sw=2

" ripgrep
if executable('rg')
  function! FZGrep(query, fullscreen)
    " --hidden 隠しファイルも隠しディレクトリも含める
    " --follow シンボリックリンクも含める
    " --glob   対象ファイルのファイルパターンを指定
    let command_fmt = 'rg --column --line-number --no-heading --hidden --follow --glob "!.git/*" --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  " RGマンドを定義。同名コマンドが定義されていた場合上書きする
  " RGコマンドはFZGrep関数を呼び出す
  command! -nargs=* -bang RG call FZGrep(<q-args>, <bang>0)
endif

" dein.vimインストール時に指定したディレクトリをセット
let s:dein_dir = expand('~/.cache/dein')

" dein.vimの実体があるディレクトリをセット
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vimが存在していない場合はgithubからclone
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

"if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " dein.toml, dein_layz.tomlファイルのディレクトリをセット
  let s:toml_dir = expand('~/.config/nvim')

  " 起動時に読み込むプラグイン群
  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

  " 遅延読み込みしたいプラグイン群
  call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
"endif

filetype plugin indent on
syntax enable
" set background=dark
" colorscheme hybrid

set background=dark
colorscheme gruvbox

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
