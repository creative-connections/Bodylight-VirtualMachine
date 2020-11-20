[![Build Status](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine.svg?branch=master)](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine)

# Virtual machine for Bodylight.js

This repository contains Vagrant scripts to prepare virtual machine in VirtualBox with development environment for Bodylight technology. After installation the Virtual Machine contains preinstalled and preconfigured tools (OpenModelica, Bodylight.js, Python, Julia, Jupyter and Anaconda) and is accessible as local web page (http://localhost:8080).  

## Motivation

Vagrant tool automates configuration (port forwarding, secure ssh keys, shared folders) and provisioning of virtual machine. The vagrant configuration describes configures shared folders, port forwarding and what base image to be used. During first boot selected image (in our case Scientific Linux 7) is downloaded and bootstrap scripts are launched - they install most updated version of depended software (Apache HTTPD, OpenModelica, Bodylight.js, Conda, Python, Julia, Jupyter).

Virtual machine contains all software in tested environment thus preventing claims `works on my machine` or `doesn't work on my machine`.
Additionally, virtual machine is a reference installation to compare with different environments.

## Requirements

Requirement: 
- HW: minimum 1 CPU, 4 GB RAM, min 5GB disk space.
- OS: Any OS supported by VirtualBox and Vagrant tool (succesfully tested on Windows 7,Windows 10, Ubuntu 16.04, ...)
- SW: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), succesfully tested with version Virtualbox 6.0.14 and 6.1.8 (( Note we experienced issue VERR_NEM_VM_CREATE_FAILED - need to disable Windows features (V-Host) and see howto setup Windows 10 at https://forums.virtualbox.org/viewtopic.php?f=6&t=93712))
- SW: Install [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.2.6 and 2.2.9
- SW: (optional, but recommended, but you may download master.zip instead directly - see notes after `git clone ...` bellow) Install [GIT](https://git-scm.com/download) any version. 

Some OS has their own distribution of `vagrant`, `virtualbox` and `git`, so you may try to use it: `yum install vagrant virtualbox git` OR `apt install vagrant virtualbox git`.

## Pre installation steps

**(Optional)** This is not required, but recommended step to clone repository of demo Jupyter notebooks and/or Physiolibrary-models next to the Bodylight-VirtualMachine on host machine,
it will appear as /vagrant_data in virtual machine and will be available for jupyter notebook after installation.
In command-line (Linux `xterm`, `bash` etc. for Windows `Start-> type 'cmd' -> choos 'Command Prompt'`) do:
```bash
git clone https://github.com/creative-connections/Bodylight-notebooks.git
git clone https://github.com/creative-connections/Physiolibrary-models.git
```
If you do not have `git`, download and unzip master.ZIP from https://github.com/creative-connections/Bodylight-notebooks/archive/master.zip 
and https://github.com/creative-connections/Physiolibrary-models/archive/master.zip


## Installation

Clone repository with Virtual machine scripts and run vagrant up (In command-line (Linux `xterm`, `bash` etc. for Windows `Start-> type 'cmd' -> choos 'Command Prompt'`) do)
```bash
git clone https://github.com/creative-connections/Bodylight-VirtualMachine.git
cd Bodylight-VirtualMachine
vagrant up
```
If you do not have `git` then you may download and unzip manually the https://github.com/creative-connections/Bodylight-VirtualMachine/archive/master.zip and do `vagrant up` in the unzipped directory.

The first `vagrant up` takes 15-45 mins (or more depending on network speed) and The bootstrap scripts downloads, installs and configures all required software, ~500 MB of Anaconda (distribution of Python and Jupyter), ~700 MB OpenModelica, ~100 MB Julia and other packages. You may disable some bootstrap script by commenting them in `Vagrantfile`. You should see success:
```bash
    ...
    default:     [yLpj] (webpack)/buildin/global.js 472 bytes {0} [built]
    default: + exit 0
```

1.5 GB of depended packages (OpenModelica, Anaconda, Julia) are downloaded and persisted in host `/cache` subdirectory during installation. 

## Update

If you have previously installed VM and would like to update or reinstall from scratch, do:
  1. If you have any data stored in VM, save it to external storage - e.g. to shared folder `/vagrant` folder.
  2. Then destroy VM, do git pull and create VM from scratch again by:

```bash
vagrant destroy
git pull
# if you made some local changes to Vagrantfile - git pull may fail, 
# try: git stash;git pull;git stash apply
vagrant up
```
This will clean VM and install the software again - if `/cache` is present from previous installation it will use most packages from it rather to download again from Internet repositories.

## After installation

After several minutes the VM is installed and configured. 
Port forwarding is done from guest VM 80 to host 8080 by default, refer Vagrantfile for exact port number. Refer default page at http://localhost:8080

The default installation contains these applications, some available from web interface:
  * Jupyter notebook with Modelica kernel, link http://localhost:8080/jupyter/ [1]
  * OpenModelica (v 1.14) - use e.g. `OMEdit` [2]
  * Python v3 - including full Anaconda environment
  * Bodylight.js-components - HTML web components - documentation and usage at http://localhost:8080/components/
  * Bodylight.js-FMU-Compiler refer http://localhost:8080/compiler/ 
  * Bodylight.js-Composer - refer http://localhost:8080/composer/
  * Bodylight-Scenarios - Scenarios written in MD using web components http://localhost:8080/scenarios/
  * Bodylight-VirtualBody - Virtualbody using WebGL http://localhost:8080/virtualbody/
  
You may access virtual desktop using VirtualBox capabilities or you may access using `vagrant ssh`.

If you don't need VM, you can halt it using Virtualbox UI or using
```bash
vagrant halt
```
If you need VM, you can boot it again using:
```bash
vagrant up
```
To restart VM
```bash
vagrant reload
```
The second and other `vagrant up`is rapid and should take couple of seconds, because time consuming provisioning (bootstrap scripts) is already done.
  
## Bootstrap scripts

Installation scripts are preserved in `/scripts` directory, they are launched only when `vagrant up`is made first or when provisioning is explicitly requested by `vagrant up --provision`.
  
### Halt VM
To stop VM.
```bash
vagrant halt
```
To start VM again - it wil start quickly as bootstrap is not needed
```bash
vagrant up
```
To restart VM
```bash
vagrant reload
```
## Clean, Uninstall

To destroy VM and remove all VM files do the following. The files stored in shared folders /vagrant and /vagrant_data are preserved. 

```bash
vagrant destroy
```

There are preserved OpenModelica and Python (Anaconda) installation binaries in `/cache` directory. Delete cache if you don't need it anymore 
```bash
rm -rf cache
```

References:

* [1] https://github.com/OpenModelica/jupyter-openmodelica
* [2] https://openmodelica.org/
* [3] vagrant https://vagrantup.com
* [4] virtualbox https://www.virtualbox.com
* [5] Anaconda https://anaconda.org/
* [6] GIT https://git-scm.com
* 
