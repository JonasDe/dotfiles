# dotfiles

This is my own personal collection of dotfiles. It contains very personal configuration, as well as an installation script (`install.sh`) which provides some basis for dotfiles management. Some features included in this bash script can be seen below.

## `install.sh` features

* SCP dotfiles over SSH to host (files included are defined in the `.scpallow`` file)
* Deploy dotfiles over SSH to host (SSH -> Clone -> Link)
* Flag for filtering affected files to 'core' via `.coreonly`
* Flag for filtering affected files to 'offline' via `.offlineonly`
* Automatic backup prior to overwrite
* Modularizable installation with section prompts
* Bash compatible 
* Support for omitting files based on current OS


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
