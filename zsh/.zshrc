HISTFILE=~/.cache/histfile
HISTSIZE=1000
SAVEHIST=1000

# auto complete
autoload -U compinit; compinit
autoload -U bashcompinit; bashcompinit

bindkey -v

cmd_to_clip () { wl-copy <<< $BUFFER }
zle -N cmd_to_clip
bindkey '^Y' cmd_to_clip

# VCS aware
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

# prompt
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# make directory completion cute
zstyle ':completion:*' menu select
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# why is this not default
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# aliases
alias vim='nvim'
