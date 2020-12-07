# dotfiles

This is my own personal collection of dotfiles for various tooling that I come across. `install.sh` is the main entrypoint for deploying and managing the dotfiles. The intention is for the dotfiles to be deployable across multiple OSes and distros (macOS, Arch, Ubuntu) with the same script without causing conflict. This is a constant work in progress so there are no guarantees that this works out of the box.

## `install.sh` 

This shell script supports the following functionality:

* SCP dotfiles over SSH to destination host (will be applied to files defined in `.scpallow` file)
* Deploy dotfiles over SSH to destination host (SSH -> Clone -> Link)
* Flag for filtering affected files to 'core' via `.coreonly`
* Flag for filtering affected files to 'offline' via `.offlineonly`
* Automatic backup prior to overwrite
* Support for omitting files based on current OS
* Modularity - each of the above flags and ignores operate on a per-module basis. A module is a folder defined in repo root, and is added to the `SYMLINK_MAP` variable defined in `install.sh`. This variable defines where the various modules should be placed in the file system. 

*Examples*:

Link only files in .coreonly

```
./install.sh -l -c
```

Link only files in .offlineonly
```
./install.sh -l -o
```

Deploy on a remote server (will clone and link dotfiles):
```
./install.sh -d <user> <host_ip> <port>
```
Scp dotfiles in .coreonly, .offlineonly and .scpallow
```
./install.sh -o -c -s <user> <host_ip> <port>
```


Scp dotfiles in .coreonly and .scpallow
```
./install.sh -c -s <user> <host> <port>
```

Scp dotfiles in .scpallow
```
./install.sh -s <user> <host> <port>
```

Which files are considered .offlineonly
```
./install.sh -v | grep .offlineonly
```

Which files are considered .coreonly
```
./install.sh -v | grep .coreonly
```

Which files are considered .scpallow
```
./install.sh -v | grep .scpallow
```

Intended to work on multiple OSes and Distros.

By default will backup existing files.


## Usage
```
Usage: install.sh [-option]

Options:
    --help                   Print this message
    -i                       Install all packages
    -l                       Link all dotfiles
    -c                       Enables the 'core' flag, reducing the set of files operated on to those in .
    -o                       Enables the 'offline' flag, reducing the set of files operated on to those in .
    -u                       Update submodules
    -d <user> <host> <port>  Deploy whole dotfiles repo on remote host and link.
    -s <user> <host> <port>  Scp files in .scpallow to remote host
    -b                       Avoid backing up
    -r <backup_folder>       Restore old config
```

## Variables and filters

Variables:
`$SYMLINK_MAP` is used to define a dotfiles folder to a corresponding
destination on the host. If a folder is not setup here it will not be subject to
linking.


Os-specific definitions:
`$OS` is accessible and should be set to the corresponding OS variable (see code
for instructions of where to support fort a new OS). 

`$OS_IGNORE` add your personal `.<os>ignore` filename here. This can be placed
in any folder to provide symlink ignore for specific files.

`$OS_INSTALL` what function to call for your specific OS. Also


## Control Files
### .scpallow
Files have to be added to this list to be the target for the `-s` command. This limits 
the number of files transferred over SCP to that which is explicitly intended.

### .coreonly
When the `-c` flag is passed, this further restricts files included on other commands.
Only files in the `.coreonly` file will pass this check.

### .offlineonly
When the `-o` flag is passed, this further restricts files included on other commands.
Only files in the `.offlineonly` file will pass this check.

### .[os]ignore
Files on this will be ignored for all operations on this operative system. Some logic
has to be added to `install.sh` to provide support for a new OS. Code commends should
be enough to guide the user through this procedure.

### Package installation

Inside `install.sh` the function `install_packages` contains a list with function names which is run. This helps
breaking down installation of collections of packages into functional units.
Each such unit will be prompted for on commandline prior to installation.
