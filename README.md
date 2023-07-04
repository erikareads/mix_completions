# MixCompletions

Mix Task for generating shell completions for `mix`. 

## Installation

To install the mix task:

```
mix archive.install github erikareads/mix_completions tag v0.3.0
```

To cache completions for mix:

```
mix complete
```

## Bash Completions

To generate bash completions:

```
mix complete.bash
```

You'll need to source these completions, so consider writing the completions to a file.

```
mix complete.bash > .mix_completions.bash
```

Then source that file in your `.bashrc`:

```
source $HOME/.mix_completions.bash
```

## Zsh Completions

To generate zsh completions:

```
mix complete.zsh
```

You'll need to save the completions as a function on the zsh `fpath`, for example:

```
mix complete.zsh > ~/.zsh/functions/_mix
```

And in the `.zshrc`:

```
fpath=(~/.zsh/functions $fpath)
autoload -Uz compinit
compinit
```

## Fish Completions

`fish` already has completions for `mix` through community contributions: https://github.com/fish-shell/fish-shell/blob/master/share/completions/mix.fish
