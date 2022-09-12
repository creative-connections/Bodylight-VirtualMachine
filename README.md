[![Build Status](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine.svg?branch=master)](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine)
[![DOI](https://zenodo.org/badge/203830641.svg)](https://zenodo.org/badge/latestdoi/203830641)
# Virtual machine for Bodylight.js

This repository contains scripts and configuration to create development environment for Bodylight tool chain. Base box is minimal Scientific Linux and Vagrant scripts prepare the rest of virtual machine with OpenModelica, Bodylight.js, Python 3.x, Julia, Jupyter, Anaconda, http server. See web apps after installation at http://localhost:8080.  
A binary snapshots are sometimes created usually in yearly (or less) bases.

All the tools are provided as is - usually in best effort or beta version quality. If it works, than it works, if something is wrong, see logs, console logs, submit issue. 

## Motivation

Vagrant tool automates configuration (port forwarding, secure ssh keys, shared folders) and provisioning of virtual machine and creates exemplar configuration. Thus preventing excuses: `works on my machine` or `doesn't work on my machine`. 

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

Choose either installation from sources or binary VM installation.

### From binary image 

* replace `Vagrantfile` with `Vagrantfile.preinstalled` where scripts are modified to download prepared image and configure the machine only.
In linux BASH:   
```bash
git clone https://github.com/creative-connections/Bodylight-VirtualMachine.git
cd Bodylight-VirtualMachine
cp Vagrantfile.preinstalled Vagrantfile
```

or in windows command
```cmd
git clone https://github.com/creative-connections/Bodylight-VirtualMachine.git
cd Bodylight-VirtualMachine
copy /Y Vagrantfile.preinstalled Vagrantfile
```

* Download manually box file (4.6GB) from https://filedn.com/lHGc7w3H4jOpIe46u1nPt57/BodyligthVMImage/21.10/bodylightvm.box
* place the box file next to the Vagrantfile
* start vagrant up by 
```bash
vagrant up 
```


### From sources - default
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

### From binary image
## Update

If you have previously installed VM and would like to update or reinstall from scratch, do:
  1. Save any documents/data from VM to shared folder `/vagrant` folder. Other files and data will be erased.
  2. Then do following:

```bash
vagrant destroy
vagrant box update
git pull
# if you made some local changes to Vagrantfile - git pull may fail, 
# try: git stash;git pull;git stash apply
vagrant up
```
This will clean VM,checkand update the base box and install the software again - if `/cache` is present from previous installation it will use most packages from it rather to download again from Internet repositories.

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
