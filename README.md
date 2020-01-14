[![Build Status](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine.svg?branch=master)](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine)

# Virtual machine for Bodylight.js

This repository contains Vagrant scripts to prepare virtual machine in VirtualBox with development environment for Bodylight technology. After installation the Virtual Machine contains preinstalled and preconfigured tools (OpenModelica, Bodylight.js, Python, Julia, Jupyter and Anaconda) and is accessible as local web page (http://localhost:8080).  

## Motivation

Vagrant tool automates configuration and provisioning of virtual machine. The vagrant configuration describes configures shared folders, port forwarding and what base image to be used. During first boot selected image (in our case Scientific Linux 7) is downloaded and bootstrap scripts are launched - they install most updated version of depended software (Apache HTTPD, OpenModelica, Bodylight.js, Conda, Python, Julia, Jupyter).

Virtual machine contains all software in tested environment thus preventing claims `works on my machine` or `doesn't work on my machine`.
Additionally, virtual machine is a reference installation to compare with different environments.

## Requirements

Requirement: 
- HW: 1 CPU, 2 GB RAM, 5-50GB disk space.
- OS: Any OS supported by VirtualBox and Vagrant tool (tested on Windows 7,Windows 10, Ubuntu 16.04)
- SW: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) tested version Virtualbox 6.0.14.(( Note we experienced issue VERR_NEM_VM_CREATE_FAILED - need to disable Windows features (V-Host) and see howto setup Windows 10 at https://forums.virtualbox.org/viewtopic.php?f=6&t=93712))
- SW: Install [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.2.6

Some OS has their own distribution of vagrant and virtualbox: `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`.
During installation - 1.5 GB of depended packages (OpenModelica, Anaconda, Julia) are downloaded and persisted in host `/cache` subdirectory. 


## Installation

Type in your command line:

```bash
git clone https://github.com/creative-connections/Bodylight-VirtualMachine.git
cd Bodylight-VirtualMachine
vagrant up
```
This first `vagrant up` takes 15-45 mins (or more depending on network speed). As the bootstrap scripts installs and configures all required software. After that, you should see success.
```bash
    ...
    default:     [yLpj] (webpack)/buildin/global.js 472 bytes {0} [built]
    default: + exit 0
```

## Update
If you have previously installed VM and would like to update
  1. If you have any data stored in VM, save it to external storage - e.g. to shared folder `/vagrant` folder.
  2. Then to update VM environment: destroy VM, do git pull and create VM from scratch again by:

```bash
vagrant destroy
git pull
vagrant up
```
This will clean VM and install the software again - if `/cache` is present from previous installation it will use it rather to download again from Internet repositories.

## After installation
After several minutes the VM is installed and configured. 
Port forwarding is done from guest VM 80 to host 8080 by default, refer Vagrantfile for exact port number. Refer default page at http://localhost:8080

The default installation contains these applications, some available from web interface:
  * Jupyter notebook with Modelica kernel, link http://localhost:8080/jupyter/ [1]
  * OpenModelica (v 1.13.2) - use e.g. `OMEdit` [2]
  * Python v 3
  * Bodylight components - Bodylight.js-FMU-Compiler, 
  * Bodylight.js-Composer - refer http://localhost:8080/composer/
  * Bodylight-Scenarios - refer http://localhost:8080/virtualbody/
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
and optionally delete cache of installation packages in 
```bash
rm -rf cache
```

References:

* [1] https://github.com/OpenModelica/jupyter-openmodelica
* [2] https://openmodelica.org/
* [3] vagrant https://vagrantup.com
* [4] virtualbox https://www.virtualbox.com

