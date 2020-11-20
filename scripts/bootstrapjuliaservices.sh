#!/usr/bin/env bash
#set -x
# optionally install julia dependencies for jupyter (ijulia) and demo notebook using rdatasets
# Pkg.add(\"RDatasets\");Pkg.add(\"Gadfly\")
/home/vagrant/julia-1.3.0/bin/julia -e "using Pkg; Pkg.add(\"IJulia\");"
sudo systemctl stop jupyter
sudo systemctl start jupyter
echo "Optional Julia packaged installed."
echo "Bootstrap finished, VM should be created and ready. See web http://localhost:8080/ for further info."
exit 0
