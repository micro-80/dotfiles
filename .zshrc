export SSH_AUTH_SOCK=${HOME}/.ssh/agent
if ! pgrep -u ${USER} ssh-agent > /dev/null; then
    rm -f ${SSH_AUTH_SOCK}
fi
if [ ! -S ${SSH_AUTH_SOCK} ]; then
    eval $(ssh-agent -a ${SSH_AUTH_SOCK} 2> /dev/null)
fi
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
	exec sway
fi

alias compileEmacs="./autogen.sh && ./configure --with-tree-sitter --with-pgtk --with-native-compilation CFLAGS='-O2 -pipe -march=native' && make -j16 && sudo make install"

PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/user/.zshrc'
autoload -Uz compinit
compinit
