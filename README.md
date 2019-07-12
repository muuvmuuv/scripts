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

- [./_utils.sh](./_utils.sh)
- [./utils/text.sh](./utils/text.sh)
- [./utils/functions.sh](./utils/functions.sh)
- [./utils/components.sh](./utils/components.sh)
- [./utils/spinner.sh](./utils/spinner.sh)
- [./utils/execute.sh](./utils/execute.sh)

> You can see all utilities in action by running the test
> script: `bash ./_tests.sh`

## Previews


| docker-stop-by-port | time-machine-exclude | utils |
|---|---|---|
| ![stop][1] | ![tmexclude][2] | ![utils][3] |

[1]: ./assets/docker-stop-by-port.gif
[2]: ./assets/time-machine-exclude.gif
[3]: ./assets/utils.gif
