# Copyright 2013-2023 The Cobra Authors
# Copyright 2023 Erika Rowland
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule Mix.Tasks.Complete.Bash do
  use Mix.Task

  @shortdoc "Output bash completion source for mix"
  def run(_) do
    Mix.Tasks.Complete.run([])

    IO.puts("""
    __mix_completion_debug() {
      if [[ -n ${BASH_COMP_DEBUG_FILE-} ]]; then
        echo "$*" >>"${BASH_COMP_DEBUG_FILE}"
      fi
    }

    __mix_completion_handle_standard_completion_case() {
      local tab=$'\t' comp

      local longest=0
      local compline
      # Look for the longest completion so that we can format things nicely
      while IFS='' read -r compline; do
        [[ -z $compline ]] && continue
        # Strip any description before checking the length
        comp=${compline%%$tab*}
        # Only consider the completions that match
        [[ $comp == "$cur"* ]] || continue
        COMPREPLY+=("$compline")
        if ((${#comp} > longest)); then
          longest=${#comp}
        fi
      done <<<"$completions"

      # If there is a single completion left, remove the description text
      if ((${#COMPREPLY[*]} == 1)); then
        comp="${COMPREPLY[0]%%$tab*}"
        COMPREPLY[0]=$comp
      else # Format the descriptions
        __mix_completion_format_comp_descriptions $longest
      fi
    }

    __mix_completion_format_comp_descriptions() {
      local tab=$'\t'
      local comp desc maxdesclength
      local longest=$1

      local i ci
      for ci in ${!COMPREPLY[*]}; do
        comp=${COMPREPLY[ci]}
        # Properly format the description string which follows a tab character if there is one
        if [[ "$comp" == *$tab* ]]; then
          desc=${comp#*$tab}
          comp=${comp%%$tab*}

          # $COLUMNS stores the current shell width.
          # Remove an extra 4 because we add 2 spaces and 2 parentheses.
          maxdesclength=$((COLUMNS - longest - 4))

          # Make sure we can fit a description of at least 8 characters
          # if we are to align the descriptions.
          if ((maxdesclength > 8)); then
            # Add the proper number of spaces to align the descriptions
            for ((i = ${#comp}; i < longest; i++)); do
              comp+=" "
            done
          else
            # Don't pad the descriptions so we can fit more text after the completion
            maxdesclength=$((COLUMNS - ${#comp} - 4))
          fi

          # If there is enough space for any description text,
          # truncate the descriptions that are too long for the shell width
          if ((maxdesclength > 0)); then
            if ((${#desc} > maxdesclength)); then
              desc=${desc:0:$((maxdesclength - 1))}
              desc+="…"
            fi
            comp+="  ($desc)"
          fi
          COMPREPLY[ci]=$comp
        fi
      done
    }

    _mix_complete_complete() {
      local options
      local IFS=$' \t\n'

      local words=("${COMP_WORDS[@]}")
      local cword=$COMP_CWORD
      local prev=$3
      local cur="${words[$cword]}"

      COMPREPLY=()

      if [[ -f 'mix.exs' && -f '.mix_complete.cache' ]]; then
        options=$(cat .mix_complete.cache)
      elif [[ ! -z "$XDG_CACHE_HOME" && -f "$XDG_CACHE_HOME/.mix_complete.cache" ]]; then
        options=$(cat "$XDG_CACHE_HOME/.mix_complete.cache")
      elif [[ -f "$HOME/.cache/.mix_complete.cache" ]]; then
        options=$(cat "$HOME/.cache/.mix_complete.cache")
      else
        options=""
      fi

      completions="$options"

      __mix_completion_debug "==$(date)=="
      __mix_completion_debug "cur $cur"
      __mix_completion_debug "words $words"
      if [[ $prev == 'mix' ]]; then
        __mix_completion_handle_standard_completion_case
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
