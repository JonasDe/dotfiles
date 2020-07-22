# dotfiles

This is my own personal collection of dotfiles. It contains very personal configuration, as well as an installation script (`install.sh`) which provides some basis for dotfiles management. I decided to make my own since I felt there was no script / tool out there that could handle all my requirements. Some features included in this bash script can be seen below.

## `install.sh` features

* SCP dotfiles over SSH to host (TODO)
* Deploy dotfiles over SSH to host (SSH -> Clone -> Link)
* Marking dotfiles as 'core' and 'offline', used to control which files the
commands will affect. Can be seen as a filter on which files to operate. 
* Automatic backup
* Restore
* Modularizable installation
* Bash compatible 
* Os-specific ignore


*Examples*:

Link only files marked 'core' (containing the string "__core")

```
./install.sh -l -c
```

Link only files marked 'offline' (containing the string "__offline")
```
./install.sh -l -o
```
Deploy on a remote server (will clone and link dotfiles):
`install.sh -d <ssh args>`
example:
```
./install.sh -d test@0.0.0.0 -p 14403
```

TODO:
Scp dotfiles marked 'core' to remote host (from home path)
```
./install.sh -c -s user@destination
```

TODO:
Scp to host files marked offline
```
./install.sh -o -s user@destination
```

Intended to work on multiple OSes and Distros.

By default will backup existing files.


## install.sh
```
Usage: install.sh [-option]

Options:
    --help                   Print this message
    -i                       Install all packages
    -l                       Link all dotfiles
    -c                       Enables the 'core' flag, reducing the set of files operated on to those with with '__core' in the filename.
                             dotfiles considered 'core']
    -u                       Update submodules
    -d <ssh_args>            Deploy dotfiles on remote host 
    -b                       Avoid backing up
    -r <backup_folder>       Restore old config
```

## Operations

Variables:
`$SYMLINK_MAP` is used to define a dotfiles folder to a corresponding
destination on the host. This is what controls the symlinking.


Os-specific definitions):
`$OS` is accessible and should be set to the corresponding OS variable (see code
for instructions of where to add it). 

`$OS_IGNORE` add your personal `.<os>ignore` filename here. This can be placed
in any folder to provide symlink ignore for specific files.

`$OS_INSTALL` what function to call for your specific OS. Also

File suffix-flags:
Appending a suffix-flag to a dotfiles name will modify how the script deals with
those files. The following is a list of available such flags:

Offline:
TODO: A suffix-flag for files that are to be considered 'usable offline'. 
The main usecase here is to filter the files that are copied over with SCP, in
case the host doesn't have internet access and it is still better to have a
subset of the files rather than none.

Simply add `__offline` as a suffix to your dotfiles. The linker will strip this
suffix when deploying the dotfiles anyway.

Core:
TODO: A suffix-flag for files that are to be considered 'core'. 

Simply add `__core` as a suffix to your dotfiles. The linker will strip this
suffix when deploying the dotfiles anyway.

### install

`install_packages` contains a list with function names which is run. This helps
breaking down installation of collections of packages into functional units.
Each such unit will be prompted for on commandline prior to installation.
