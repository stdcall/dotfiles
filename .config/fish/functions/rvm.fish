function rvm
  set SHELL /bin/bash
  set -l fish_env (env)
  set -l bash_env (bash -c "source ~/.rvm/scripts/rvm; rvm $argv; echo HEYSPLITHERE; env")


  set -l common

  for env in $bash_env

    if test -z "$capture"
      if test $env = 'HEYSPLITHERE'
        set capture '1'
      else
        echo $env
      end
      continue
    end

    if not contains $env $fish_env
      set common $common $env
    end
  end

  __bash_env_to_fish $common
  set SHELL (which fish)
end
# vim: ft=fish:ts=2
