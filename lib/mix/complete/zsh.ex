defmodule Mix.Tasks.Complete.Zsh do
  use Mix.Task

  @shortdoc "Output zsh completion source for mix"
  def run(_) do
    Mix.Tasks.Complete.run([])

    IO.puts("""
    #compdef mix

    _mix() {
      local options completion_line filtered_options
      local -a completions
      local current_word=${words[-1]}
      local previous_word=${words[-2]}

      if [[ -f 'mix.exs' && -f '.mix_complete.cache' ]]; then
        options=$(cat .mix_complete.cache)
      elif [[ ! -z "$XDG_CACHE_HOME" && -f "$XDG_CACHE_HOME/.mix_complete.cache" ]]; then
        options=$(cat "$XDG_CACHE_HOME/.mix_complete.cache")
      elif [[ -f "$HOME/.cache/.mix_complete.cache" ]]; then
        options=$(cat "$HOME/.cache/.mix_complete.cache")
      else
        options=""
      fi

      filtered_options=$(echo "$options" | grep "^$current_word")

      while IFS='\n' read -r completion_line; do
        if [ -n "$completion_line" ]; then
          # zsh's _describe needs a : instead of a TAB.
          # So we first escape any : as part of the completion itself.
          completion_line=${completion_line//:/\\:}

          local tab="$(printf '\t')"
          completion_line=${completion_line//$tab/:}

          completions+=${completion_line}
        fi
      done <<<"$filtered_options"

      if [[ $previous_word == 'mix' ]]; then
        _describe "completions" completions
      else
        _arguments '*:filenames:_files'
      fi
    }
    """)
  end
end
