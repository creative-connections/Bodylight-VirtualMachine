[![Build Status](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine.svg?branch=master)](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine)

# Virtual machine for Bodylight.js

This is vagrant script to prepare devel VM from scratch

## Requirements

Requirement: 
- HW: 1 CPU, 2 GB RAM, 5-50GB disk space.
- OS: Any OS supported by VirtualBox and Vagrant tool (tested on Windows 7,Windows 10, Ubuntu 16.04)
- SW: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) tested version Virtualbox 6.0.14.(( Note we experienced issue VERR_NEM_VM_CREATE_FAILED - see howto setup Windows 10 at https://forums.virtualbox.org/viewtopic.php?f=6&t=93712))
- SW: Install [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.2.6

Some OS has their own distribution of vagrant and virtualbox: `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`.

## Installation

Type in your command line:

```bash
git clone https://github.com/creative-connections/Bodylight-VirtualMachine.git
cd Bodylight-VirtualMachine
vagrant up
```
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

To destroy VM and remove all VM files do the following. The files stored in shared folders /vagrant and /vagrant_data are preserved. 
```bash
vagrant destroy
```


References:

* [1] https://github.com/OpenModelica/jupyter-openmodelica
* [2] https://openmodelica.org/
* [3] vagrant https://vagrantup.com
* [4] virtualbox https://www.virtualbox.com

