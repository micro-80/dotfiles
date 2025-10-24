# Modus Themes for Tmux
# Auto generated with https://github.com/miikanissi/modus-themes.nvim/blob/master/lua/modus-themes/extras/tmux.lua

set-option -g status-position "bottom"
set-option -g status-style bg=#675072,fg=#fedeff
set-option -g status-left '#[bg=#675072,fg=#fedeff,bold]#{?client_prefix,,  tmux  }#[bg=#80aadf,fg=#322f34,bold]#{?client_prefix,  tmux  ,}'
set-option -g status-right '#S'
set-option -g window-status-format ' #I:#W '
set-option -g window-status-current-format '#[bg=#80aadf,fg=#322f34] #I:#W#{?window_zoomed_flag,  , }'
