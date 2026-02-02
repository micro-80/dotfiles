path+=($HOME/.bin)

export EDITOR=nvim
function install_nvim_nightly_mac () {
	mkdir -p "$HOME/.bin/data/nvim-nightly"
	curl -L -o /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz 
	xattr -c /tmp/nvim.tar.gz
	tar xzvf /tmp/nvim.tar.gz -C "$HOME/.bin/data/nvim-nightly" --strip-components=1
	ln -sf "$HOME/.bin/data/nvim-nightly/bin/nvim" "$HOME/.bin/nvim"
}
function install_nvim_nightly_linux () {
	mkdir -p "$HOME/.bin/data/nvim-nightly"
	curl -L -o /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz 
	tar xzvf /tmp/nvim.tar.gz -C "$HOME/.bin/data/nvim-nightly" --strip-components=1
	ln -sf "$HOME/.bin/data/nvim-nightly/bin/nvim" "$HOME/.bin/nvim"
}

export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

autoload -U compinit; compinit

fpath+=($XDG_CONFIG_HOME/zsh/pure)
autoload -U promptinit; promptinit
prompt pure
# single line
prompt_newline='%666v'
PROMPT=" $PROMPT"
# no new line between prompts
print() {
	[[ $# -eq 0 && ${funcstack[-1]} = prompt_pure_precmd ]] || builtin print "$@"
}
