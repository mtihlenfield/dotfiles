# dotfiles

Linux dotfiles and scripts for installing my development environment

Use `./install.sh` for a normal internet connected install.

`./install.sh package` can be used to generate a tarball that can be used to install all of binaries/dependencies in a system that is not connected to the internet (but still have an apt and pip mirr).  You can use `package-dockerized.sh` to generate the package from a clean docker container.

To install the offline package, untar the tarball, cd in to `dotfiles`, and run `./install.sh unpack`

The provided Dockerfile can be used for testing. It has three targets:

1. dotfiles-base: This is a base ubuntu:20.04 with a user added 
2. dotfiles: this is dotfiles-base, but the build runs the `./install.sh` script in order to install the development environment
3. dotfiles-offline-test: This starts from dotfiles-base and uses the dotfile.tar.gz package tarball do perform an offline install. In order to build this you must first generate a dotfiles.tar.gz package tarball with either `./install.sh package` or `./package-dockerized.sh`

