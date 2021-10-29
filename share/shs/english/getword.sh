zsh ./daydict.sh $1 | shuf | xargs -n 1 zsh ./dict.sh | less
