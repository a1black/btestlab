[[ -s $HOME/.profile ]] && . $HOME/.profile

# Setup shell enviroment variables
export EDITOR='vim'
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
export HISTIGNORE="clear:dir:ls:l[clw1]:[bf]g:exit:%[0-9]:top:htop"
export HISTSIZE=4000
export HISTFILESIZE=4000

# Bash Shell options
shopt -so vi
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s hostcomplete
shopt -s autocd
shopt -s globstar
shopt -s nocaseglob

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Prompt autocomplition
if ! shopt -oq posix ; then
    [[ -f /etc/bash_completion ]] && . /etc/bash_completion
fi

# Software settings
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
stty -ixon
export LESS='-iXFJMRs'
export LESSHISTFILE="/dev/null"
export PS1_ENV_NAME_LEN=14

# User defined commands
# Travel up the file tree.
# Args:
#   $1      Number of levels to travel (default: 1)
up() {
    local path=".."
    for ((i=2; i<=${1:-1}; i++)); do
        path=$path/..
    done
    cd $path
}
# Function to generate random string.
# Args:
#   $1      String length (default: 8)
#   $2      Number of strings to generate (default: 1)
genpass() {
    local len=8 choices=1
    if [[ "$1" =~ ^[0-9]+$ && "$1" -gt 7 ]]; then
        len="$1"
    fi
    if [[ "$2" =~ ^[0-9]+$ && "$2" -gt 1 ]]; then
        choices="$2"
    fi
    tr -dc '[:alnum:]' < /dev/urandom | fold -w $len | head -n $choices
}
# Function to display processes that utilize inotify watchers.
# Args:
#   $1      Filter process list by the number of watchers (default: 100)
iwatchers() {
    local min=${1:-100} procs=0 total=0 cnt=0 pid=0 cmd
    printf "%6s %8s  %s\n" "COUNT" "PID" "COMMAND"
    while read watcher; do
        cnt=${watcher##*:}
        pid=${watcher%%:*}
        ((total += cnt))
        ((procs++))
        if ((cnt >= min)); then
            cmd=$(ps -o command= -p $pid)
            ((${#cmd} >= 79)) && cmd="${cmd:0:30}...${cmd: -46}"
            printf "%6d %8d  %s\n" "$cnt" "$pid" "$cmd"
        fi
    done < <(find /proc/*/fd -ilname anon_inode:*inotify* -printf '%h:' \
                -execdir grep -c '^inotify' ../fdinfo/{} \; 2> /dev/null | \
                sed -E 's/[^0-9:]//g ; /:0$/d' | sort -nr -t: -k2)
    printf -- "----------------------------------------\n"
    printf "%d  use  %d of %d" "$procs" "$total" "$(cat /proc/sys/fs/inotify/max_user_watches)"

}

# Alias definitions
if [[ -x /usr/bin/dircolors ]]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi
alias ll='ls -AlF --human-readable --escape'
alias lw='ls -AlF --human-readable --escape --group-directories-first'
alias lc='ls -CF --escape --group-directories-first'
alias l1='ls -1F --escape --group-directories-first'
if command -v xsel &> /dev/null; then
    alias pbcopy='xsel -i -b'
    alias pbpaste='xsel -o -b'
elif command -v xclip &> /dev/null; then
    alias pbcopy='xclip -selection -c'
    alias pbpaste='xclip -selection clipboard -o'
fi
alias memtotal="smem -t -k -c pss -P"

# Solarized theme prompt colors
reset=$'\e[0m'
bold=$'\e[1m'
underline=$'\e[4m'
blink=$'\e[5m'
revs=$'\e[7m'
if [[ $TERM =~ 256color ]]; then
    # Solarized colors, taken from http://git.io/solarized-colors.
    black=$'\e[38;5;0m'
    blue=$'\e[38;5;33m'
    cyan=$'\e[38;5;37m'
    green=$'\e[38;5;64m'
    orange=$'\e[38;5;130m'
    purple=$'\e[38;5;125m'
    red=$'\e[38;5;124m'
    violet=$'\e[38;5;61m'
    white=$'\e[38;5;15m'
    yellow=$'\e[38;5;136m'
else
    black=$'\e[30m'
    blue=$'\e[34m'
    cyan=$'\e[36m'
    green=$'\e[32m'
    orange=$'\e[33m'
    purple=$'\e[35m'
    red=$'\e[31m'
    violet=$'\e[95m'
    white=$'\e[97m'
    yellow=$'\e[33m'
fi;

# Command color output setup
export LESS_TERMCAP_mb=$blink$red        # begin blinking
export LESS_TERMCAP_md=$bold$yellow      # begin bold
export LESS_TERMCAP_me=$reset            # end mode
export LESS_TERMCAP_se=$reset            # end standout-mode
export LESS_TERMCAP_so=$revs$green       # begin standout-mode
export LESS_TERMCAP_ue=$reset            # end underline
export LESS_TERMCAP_us=$underline$violet # begin underline
export GROFF_NO_SGR=1
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:ow=34;47:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=47;04;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.mp4=01;35:*.mkv=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.php=00;32:*.py=00;95:*.pyc=00;40:*.conf=00;31:*rc=00;31:*.sh=00;34:'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Prompt customization
_prompt_git_status_simple() {
    # Check if the current directory is ".git"
    [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) != 'true' ]] && return
    # Branch name
    local branch=$(git symbolic-ref --quiet --short HEAD 2> /dev/null)
    local brcom=$(git rev-parse --short HEAD 2> /dev/null)
    local marks=''
    local bc=$green
    # Update index
    git update-index --really-refresh -q &> /dev/null
    # Staged changes
    ! git diff --quiet --ignore-submodules --cached && marks+='*' && bc=$yellow
    # Unstaged changes
    ! git diff --quiet --ignore-submodules && marks+='+' && bc=$cyan
    # Untracked files
    [[ $(git ls-files -o --exclude-standard | wc -l) != 0 ]] && marks+='?'
    # Unmerged files
    [[ $(git ls-files --unmerged | wc -l) != 0 ]] && marks+='!' && bc=$red
    # Stashed changes
    git rev-parse --verify refs/stash &> /dev/null && marks+='#'
    # Form git status string
    if [[ -z "$branch" && -z "$brcom" ]]; then
        branch='(unknown)'
    elif [[ -z "$branch" ]]; then
        branch="$brcom"
    else
        branch="$branch($brcom)"
    fi
    [[ -n "$marks" ]] && marks=" [$marks] "
    printf '\001%s%s\002 %s \001%s\002%s\001%s\002' $revs $bc "$branch" $blue "$marks" $reset
}
_prompt_uid_color() {
    if [[ $UID == 0 ]]; then
        printf '\001%s\002\001%s\002' $bold $red
    elif sudo -n true &> /dev/null; then
        printf '\001%s\002\001%s\002' $bold $purple
    else
        printf '\001%s\002' $orange
    fi
}
_prompt_virtualenv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local virtenv_name=$(basename $VIRTUAL_ENV)
        local virtenv_len=${PS1_ENV_NAME_LEN:-12}
        if [[ ${#virtenv_name} -gt $virtenv_len ]]; then
            local virt_left=$(( ($virtenv_len-2)/3 ))
            local virt_right=$(( $virtenv_len-2-$virt_left ))
            virtenv_name=$(echo $virtenv_name | sed -En 's/(.{'$virt_right'}).*(.{'$virt_left'})/\1..\2/p')
        fi
        printf '\001%s%s\002 \u24d4 %s \001%s\002' $revs $violet $virtenv_name $reset
    fi
}

PS1="\n\$(_prompt_uid_color)\u\[$reset\]"
[ -n "$SSH_TTY" ] && PS1+="\[$blue\]@\[$bold\]\[$purple\]\h\[$reset\]"
PS1+="\[$blue\] in "
PS1+="\[$green\]\w"
PS1+="\n"
PS1+="\[$revs\]\[$white\]\[$bold\]\A \[$reset\]"
PS1+="\$(_prompt_virtualenv)"
PS1+="\$(_prompt_git_status_simple)"
PS1+=" \$(_prompt_uid_color)\$ \[$reset\]"
export PS1
PS2="\[$yellow\]→ \[$reset\]"
export PS2

# Source FZF shell scripts
if command -v fzf &> /dev/null ; then
    fzf_home=$(command -v fzf | xargs realpath | xargs dirname | sed 's/\/bin$//')
    [[ -s $fzf_home/shell/key-bindings.bash ]] && . "$fzf_home/shell/key-bindings.bash"

    export FZF_DEFAULT_OPTS='--no-height --no-reverse'
    export FZF_CTRL_T_OPTS='--select-1 --exit-0 --color=bw --preview "(highlight -O ansi -l {} 2> /dev/null || cat {} || ls --color=always -1 {}) 2> /dev/null | head -100"'
    export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window down:3:hidden:wrap --bind "?:toggle-preview"'

    unset fzf_home
fi

# vi: et ft=sh sw=4 ts=4
