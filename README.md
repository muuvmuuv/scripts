# Scripts

Some scripts I use on my local macOS machine. For the best
experience enable blinking text in your terminal of choice.

## Scripts

- [./docker-stop-by-port.sh](./docker-stop-by-port.sh)
- [./time-machine-exclude.sh](./time-machine-exclude.sh)
- [./update-prezto.sh](./update-prezto.sh)
- [./image-to-icns.sh](./image-to-icns.sh)

__Usage:__

```shell
# ~/.zprofile

alias stop="bash ~/.scripts/docker-stop-by-port.sh"
alias tmexclude="bash ~/.scripts/time-machine-exclude.sh"
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

| ![docker-stop-by-port][1] | ![time-machine-exclude][2] | ![update-prezto][3] |
| --- | --- | --- |
| ![image-to-icns][4] | ![_tests][5] | /// |

[1]: ./assets/docker-stop-by-port.svg
[2]: ./assets/time-machine-exclude.svg
[3]: ./assets/update-prezto.svg
[4]: ./assets/image-to-icns.svg
[5]: ./assets/_tests.svg
