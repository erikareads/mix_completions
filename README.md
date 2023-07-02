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

## Notice

This repo uses modified code for shell completions from [`cobra`](https://github.com/spf13/cobra), 
the following is a notice of their copyright as required by Apache License 2.0.

```
Copyright 2013-2023 The Cobra Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
