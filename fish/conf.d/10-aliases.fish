# ~/.config/fish/conf.d/aliases.fish
# Loaded automatically by fish for every interactive shell.

status is-interactive; or exit

# --- Directory navigation (Oh My Zsh style) ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

function back --wraps='cd -' --description 'Go to previous directory'
    cd -
end

# Make directory helpers
alias md='mkdir -p'            # OMZ-style
function mcd                   # make and cd
    test -n "$argv[1]"; or return 1
    mkdir -p -- "$argv[1]"; and cd -- "$argv[1]"
end

# --- Listing shortcuts: prefer eza, fall back to ls ---
if type -q eza
    # eza: modern ls replacement
    alias l='eza -lh --group-directories-first'
    alias la='eza -lha --group-directories-first'
    alias ll='eza -lh --group-directories-first'
    alias lla='eza -lha --group-directories-first'
    alias lt='eza -lT --level=2 --group-directories-first' # small tree
    alias l.='eza -d .*'                                   # dotfiles in cwd
    alias tree='eza -T'          # tree view
else
    # Fallback to plain ls
    alias l='ls -lh'
    alias la='ls -lha'
    alias ll='ls -lh'
    alias lla='ls -lha'
    alias l.='ls -d .*'
    alias tree='tree' # use system tree if installed
end
