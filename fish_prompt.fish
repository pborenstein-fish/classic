# Fish git prompt
set __fish_git_prompt_showdirtystate        'yes'
set __fish_git_prompt_showstashstate        'yes'
set __fish_git_prompt_showupstream          'yes'
set __fish_git_prompt_showuntrackedfiles    'yes'
set __fish_git_prompt_showupstream          'yes'

set __fish_git_prompt_color                 yellow
set __fish_git_prompt_color_branch          yellow
set __fish_git_prompt_color_untrackedfiles  red
set __fish_git_prompt_color_dirtystate      yellow
set __fish_git_prompt_color_stagedstate     green

set __fish_virtualfish_color_env			990

set __fish_git_prompt_char_stateseparator ' '

#     dirtystate          unstaged changes (*)
#     stagedstate         staged changes   (+)
#     invalidstate        HEAD invalid     (#, colored as stagedstate)

# set __fish_git_prompt_show_informative_status 1

function fish_prompt
  if not set -q __fish_prompt_hostname
     set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  printf "\n"
  
  # Put the iterm2 dingus after the empty line if we're running iterm
  type -q iterm2_prompt_mark && iterm2_prompt_mark  

  set_color $fish_color_user
  printf "%s@%s: " $USER $__fish_prompt_hostname

    # Don't use the abbreviated path
    # that prompt_pwd provides
  set_color $fish_color_cwd
  printf "%s\n" (echo $PWD | sed -e "s|^$HOME|~|")

    # Is there a Python virtualenv?
    # we're using http://virtualfish.readthedocs.org/en/latest/
    # also vfextras.fish
  if begin; set -q VIRTUAL_ENV; and set -q VIRTUAL_ENV_PROMPT; end
    echo -n -s  (set_color $__fish_virtualfish_color_env)  (basename "$VIRTUAL_ENV") (set_color normal)
    echo -n -s  (set_color $fish_color_cwd) " "
  end


    # Save and print git part of the prompt
  set -l prompt (fish_git_prompt "[%s]")
  printf '%s' "$prompt"

    # if it's longer than a bunch chars throw in a newline
    # 60 is magic number for the escap sequences
    #   (which get counted in the string length)
  if test (math -s0 (string length $prompt) + 60 ) -gt 200
    printf "%s" "\n"
  end

  set_color cyan
  printf '%s ' "\$"
  set_color normal
end

