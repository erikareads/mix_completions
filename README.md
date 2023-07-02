# MixCompletions

Mix Task for generating shell completions for `mix`. 

## Installation

To install the mix task:

```
mix archive.install github erikareads/mix_completions tag v0.2.0
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

The source that file in your `.bashrc`:

```
source $HOME/.mix_completions.bash
```
