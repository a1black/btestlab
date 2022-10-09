export NODE_HOME="$HOME/.local/share/node"

# Include localy installed software
[[ -d $HOME/bin && ! $PATH =~ $HOME/bin: ]] && PATH="$HOME/bin:$PATH"
[[ -d $HOME/.local/bin && ! $PATH =~ $HOME/.local/bin: ]] && PATH="$HOME/.local/bin:$PATH"
# Node packeges installed per user
[[ -n $NODE_HOME && -d $NODE_HOME/bin && ! $PATH =~ $NODE_HOME/bin: ]] && PATH="$NODE_HOME/bin:$PATH"

export PATH

# vi: et ft=sh sw=4 ts=4
