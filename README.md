[![Build Status](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine.svg?branch=master)](https://travis-ci.org//creative-connections/Bodylight-VirtualMachine)

# Virtual machine for Bodylight.js

This is vagrant script to prepare devel VM from scratch

## Requirements

Requirement: 
- HW: 1 CPU, 2 GB RAM, 5-50GB disk space.
- OS: Any OS supported by VirtualBox and Vagrant tool (tested on Windows 7,Windows 10, Ubuntu 16.04)
- SW: Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html) tested version 2.1.1. Some OS has their own distribution of vagrant and virtualbox: `yum install vagrant virtualbox` OR `apt install vagrant virtualbox`.

## Local Installation Using Vagrant and Virtualbox

Type in your command line:

```bash
git clone https://github.com/creative-connections/Bodylight-VirtualMachine.git
cd Bodylight-VirtualMachine
vagrant up
```
### After installation
After several minutes the VM is installed and configured. 
Port forwarding is done from guest VM 80 to host 8080 by default, refer Vagrantfile for exact port number. Refer default page at http://localhost:8080

The default installation contains these applications, some available from web interface:
  * Jupyter notebook with Modelica kernel, link http://localhost:8080/jupyter/ [1]
  * OpenModelica (v 1.13.2) - use e.g. `OMEdit` [2]
  * Python v 3
  * Bodylight components - Bodylight.js-FMU-Compiler, 
  * Bodylight.js-Composer - refer http://localhost:8080/composer/
  * Bodylight-Scenarios - refer http://localhost:8080/virtualbody/

References:
* [1] https://github.com/OpenModelica/jupyter-openmodelica
* [2] https://openmodelica.org/
