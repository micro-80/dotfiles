function m-compile-emacs() {
    ./autogen.sh
    ./configure --with-tree-sitter --with-pgtk --with-native-compilation CFLAGS="-O2 -pipe -march=native"
    make -j16
    sudo make install
}

function m-install-iosevka() {
    local font_folder="$HOME/.local/share/fonts"
    local iosevka_folder="$HOME/Downloads/iosevka"
    mkdir -p "$font_folder" "$iosevka_folder"
    cd "$iosevka_folder"
    rm -rf "$iosevka_folder/*"
    curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | jq -r ".assets[] | .browser_download_url" | grep PkgTTC-Iosevka- | xargs -n 1 curl -L -O --fail --silent --show-error
    unzip * -d "$iosevka_folder"
    sudo fc-cache
    cd -
}

PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%# '
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
zstyle :compinstall filename '/home/user/.zshrc'
autoload -Uz compinit
compinit
