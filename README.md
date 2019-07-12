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

### Things I think about:

Maybe formatting, utils and spinner in a utils folder and
utils is just a importer of all with _utils.sh as naming.

Move everything to .scripts?
