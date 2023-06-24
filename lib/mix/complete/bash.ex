defmodule Mix.Tasks.Complete.Bash do
  use Mix.Task

  @shortdoc "Output bash completion source for mix"
  def run(_) do
    Mix.Tasks.Complete.run([])

    IO.puts("""
    _mix_complete_complete() {
    	local options

    	if [[ -f 'mix.exs' && -f '.mix_complete.cache' ]]; then
    		options=$(cat .mix_complete.cache)
    	elif [[ ! -z "$XDG_CACHE_HOME" && -f "$XDG_CACHE_HOME/.mix_complete.cache" ]]; then
    		options=$(cat "$XDG_CACHE_HOME/.mix_complete.cache")
    	elif [[ -f "$HOME/.cache/.mix_complete.cache" ]]; then
    		options=$(cat "$HOME/.cache/.mix_complete.cache")
    	else
    		options=""
    	fi

    	if [[ $3 == 'mix' ]]; then
    		for option in $options; do
    			COMPREPLY+=($(echo "$option" | grep "^$2"))
    		done
    	else
    		COMPREPLY=()
    		compopt -o default
    	fi
    }

    _mix_complete_setup() {
    	complete -F _mix_complete_complete mix
    }

    _mix_complete_setup
    """)
  end
end
