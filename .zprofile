for p in $HOME/bin $HOME/.cabal/bin /opt/bin /usr/games/bin; do
  if [[ ! -d $p ]]; then
    continue
  else
    if [[ ! $PATH == *$p* ]]; then
      PATH="$p:$PATH"
    fi
  fi
done
export PATH
