# --- Interactive guard --------------------------------------------------------
status is-interactive; or exit

# --- Auto-start tmux (but not inside tmux/screen/ssh non-interactive shells) --
if type -q tmux
    and not set -q TMUX
    and test -n "$TERM"
    and not string match -rq 'screen|tmux' -- "$TERM"
    exec tmux new-session -A -s main
end

# --- PATH (idempotent) --------------------------------------------------------
# Prefer fish_add_path so duplicates aren’t added each shell
if functions -q fish_add_path
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /usr/local/bin
    fish_add_path /home/rkrsn/.spicetify
    fish_add_path $HOME/.lmstudio/bin
else
    # Fallback for ancient fish
    set -gx PATH $HOME/bin $HOME/.local/bin /usr/local/bin /home/rkrsn/.spicetify $HOME/.lmstudio/bin $PATH
end

# --- direnv -------------------------------------------------------------------
# (Deduplicated to a single init line)
if type -q direnv
    direnv hook fish | source
end

# --- zoxide -------------------------------------------------------------------
if type -q zoxide
    zoxide init fish | source
end

# --- alias --------------------------------------------------------------------
alias nano 'micro'

# --- bun ----------------------------------------------------------------------
set -gx BUN_INSTALL "$HOME/.bun"
set -l bun_bin "$BUN_INSTALL/bin"

# Add bun to PATH once (fish_add_path avoids duplicates)
if functions -q fish_add_path
    fish_add_path $bun_bin
else
    contains $bun_bin $PATH; or set -gx PATH $bun_bin $PATH
end

if status is-interactive; and type -q bun
    set -l comp_dir ~/.config/fish/completions
    set -l comp_file $comp_dir/bun.fish
    if not test -e $comp_file
        mkdir -p $comp_dir
        # Try both syntaxes; Bun versions differ
        bun completions fish ^/dev/null > $comp_file; or bun completions --shell fish > $comp_file
    end
end

# --- pyenv --------------------------------------------------------------------
set -gx PYENV_ROOT "$HOME/.pyenv"
if test -d "$PYENV_ROOT/bin"
    if functions -q fish_add_path
        fish_add_path "$PYENV_ROOT/bin"
    else
        set -gx PATH "$PYENV_ROOT/bin" $PATH
    end
end

# Initialize pyenv for fish (interactive)
if type -q pyenv
    pyenv init - | source
end

starship init fish | source

# --- SDKMAN (Fish note) -------------------------------------------------------
# SDKMAN is bash/zsh-native. In fish, use the 'bass' plugin to source it:
#   fisher install edc/bass
# Then uncomment the line below.
# if type -q bass; and test -r "$HOME/.sdkman/bin/sdkman-init.sh"
#     bass source "$HOME/.sdkman/bin/sdkman-init.sh"
# end

# --- Prompt/theme -------------------------------------------------------------
# Your zsh used "pure". For fish, consider:
#   fisher install pure-fish/pure
# or use starship:
#   brew/dnf install starship; then: starship init fish | source
