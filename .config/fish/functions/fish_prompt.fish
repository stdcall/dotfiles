function fish_prompt --description "Write out the prompt"
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end
    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end
    set blue (set_color blue) 
    set green (set_color green) 
    set cyan (set_color cyan)
    set white (set_color white)
    printf "$green%s $cyan: %s%s%s%s" $__fish_prompt_hostname $__fish_prompt_cwd (prompt_pwd) (parse_git_branch) " $cyan» " 
end
# vim: :ts=4:ft=fish
