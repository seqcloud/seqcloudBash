# koopa 🐢

[![Build Status](https://travis-ci.org/steinbaugh/koopa.svg?branch=master)](https://travis-ci.org/steinbaugh/koopa)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Shell bootloader for bioinformatics.

## Requirements

- [Bash][] 4 (`bash --version`)
- [Python][] 3 (`python --version`)

## Installation

Bash shell running on either Linux or macOS is currently supported.

First, clone the repository:

```bash
git clone https://github.com/steinbaugh/koopa.git ~/koopa
```

Second, add these lines to `~/.bash_profile`:

```bash
# koopa shell
# https://github.com/steinbaugh/koopa
source ~/koopa/bin/koopa activate
```

Koopa should now activate at login. To obtain information on the current working enviroment, run `koopa info`.

Since workload managers (e.g. [Slurm][], [LSF][]) can spawn non-interactive login shells for new jobs, we recommend additionally symlinking `~/.bashrc` to `~/.bash_profile`. For non-interactive login shells, koopa doesn't attempt to print any messages, so the shell remains clean.

[Bash]: https://www.gnu.org/software/bash/
[LSF]: https://www.ibm.com/support/knowledgecenter/en/SSETD4/product_welcome_platform_lsf.html
[Python]: https://www.python.org/
[Slurm]: https://slurm.schedmd.com/
