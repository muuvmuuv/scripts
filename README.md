# Scripts

Some scripts I use on my local macOS machine. For the best
experience enable blinking text in your terminal of choice.

## Scripts

- [./docker-stop-by-port.sh](./docker-stop-by-port.sh)
- [./time-machine-exclude.sh](./time-machine-exclude.sh)

__Usage:__

```shell
# ~/.zprofile

alias stop="bash ~/.zsh/docker-stop-by-port.sh"
alias tmexclude="bash ~/.zsh/time-machine-exclude.sh"
```

## Utilities

- [./text.sh](./text.sh)
- [./functions.sh](./functions.sh)
- [./components.sh](./components.sh)
- [./spinner.sh](./spinner.sh)
- [./execute.sh](./execute.sh)

> You can see all utilities in action by running the test
> script: `bash ./_tests.sh`

## Previews


| docker-stop-by-port | time-machine-exclude | utils |
|---|---|---|
| ![stop][1] | ![tmexclude][2] | ![utils][3] |

[1]: ./assets/docker-stop-by-port.gif
[2]: ./assets/time-machine-exclude.gif
[3]: ./assets/utils.gif
