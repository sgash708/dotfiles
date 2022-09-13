export LSCOLORS=gxfxcxdxbxegedabagacad
export CLICOLOR=1

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit
compinit -u

autoload -Uz vcs_info
setopt prompt_subst

function left-prompt {
  name_t='179m%}'			# user name text color
  name_b='000m%}'			# user name background color
  name_s='168m%}'			# user name sharp color
  path_t='255m%}'			# path text color
  path_b='031m%}'			# path background color
  arrow='087m%}'			# arrow color
  text_color='%{\e[38;5;'		# set text color
  back_color='%{\e[30;48;5;'		# set background color
  reset='%{\e[0m%}'			# reset
  sharp='\uE0B0'			# triangle

  user="${back_color}${name_b}${text_color}${name_t}"
  dir="${back_color}${path_b}${text_color}${path_t}"
  echo "${user}%n@%m${back_color}${path_b}${text_color}${name_s}${sharp} ${dir}%~ ${reset}${text_color}${path_b}${sharp}${reset}\n${text_color}${arrow}→ ${reset}"
}

PROMPT=`left-prompt` 

# コマンドの実行ごとに改行
function precmd() {
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}

# git ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  branch='\ue0a0'
  color='%{\e[38;5;' #  文字色を設定
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  reset='%{\e[0m%}'   # reset

  if [ ! -e  ".git" ]; then
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全て commit されてクリーンな状態
    branch_status="${color}${green}${branch}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # git 管理されていないファイルがある状態
    branch_status="${color}${red}${branch}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git add されていないファイルがある状態
    branch_status="${color}${red}${branch}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commit されていないファイルがある状態
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "${color}${red}${branch}!(no branch)${reset}"
    return
  else
    # 上記以外の状態の場合
    branch_status="${color}${blue}${branch}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}$branch_name${reset}"
}
 
# プロンプトの右側にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'

alias vim='nvim .'
alias vi='nvim .'

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alF'
alias l='clear && ls'

alias sz='source ~/.zshrc'
alias sv='source ~/.config/nvim/init.vim'

. /opt/homebrew/opt/asdf/libexec/asdf.sh

unset TMPDIR

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
