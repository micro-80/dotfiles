export SSH_AUTH_SOCK=${HOME}/.ssh/agent
if ! pgrep -u ${USER} ssh-agent > /dev/null; then
    rm -f ${SSH_AUTH_SOCK}
fi
if [ ! -S ${SSH_AUTH_SOCK} ]; then
    eval $(ssh-agent -a ${SSH_AUTH_SOCK} 2> /dev/null)
fi

alias compileEmacs="./autogen.sh && ./configure --with-tree-sitter --with-pgtk --with-native-compilation CFLAGS='-O2 -pipe -march=native' && make -j16 && sudo make install"

PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
zstyle :compinstall filename '/home/user/.zshrc'
autoload -Uz compinit
compinit

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
    if [ -z "$XDG_RUNTIME_DIR" ]; then
	export XDG_RUNTIME_DIR="/run/user/$(id -u)"
	rm -rf $XDG_RUNTIME_DIR
	mkdir -p $XDG_RUNTIME_DIR
    fi
    exec dbus-run-session sway
fi
