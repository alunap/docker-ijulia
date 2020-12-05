#!/bin/bash

# Install conda
 mkdir -p $CONDA_DIR
 echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh
 wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
 /bin/bash /Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR
 rm Miniconda3-latest-Linux-x86_64.sh

conda create -n conda_jl python
julia -e 'using Pkg ; Pkg.add("Conda") ; Pkg.build("Conda") ; '

conda install --yes -c conda-forge jupyter ipywidgets numpy pandas matplotlib ipyparallel jupyterlab \
scipy seaborn scikit-learn scikit-image sympy cython patsy statsmodels cloudpickle dill numba bokeh

ln -s /opt/conda/pkgs/zeromq-4.0.*/lib/libzmq.so.4.* /opt/conda/lib/libzmq.so.4 
ln -s /opt/conda/pkgs/libsodium-0.4.*/lib/libsodium.so.4.* /opt/conda/lib/libsodium.so.4

jupyter notebook --generate-config

JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("IJulia");Pkg.add("Cairo"); Pkg.add("PyPlot"); Pkg.add("Gadfly"); Pkg.add("DataStructures"); Pkg.add("HDF5"); Pkg.add("SymPy"); Pkg.add("Interact"); Pkg.add("Roots");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("DataFrames"); Pkg.add("RDatasets"); Pkg.add("Distributions"); Pkg.add("Clustering"); Pkg.add("GLM");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("Images"); Pkg.add("ImageView"); Pkg.add("WAV"); Pkg.add("JSON"); Pkg.add("StatsPlots");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("BayesNets"); Pkg.add("PGFPlots"); Pkg.add("Chain"); Pkg.add("Plots"); Pkg.add("PyCall"); Pkg.add("ScikitLearn");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("TimeZones"); Pkg.add("Revise"); Pkg.add("Statistics"); Pkg.add("Queryverse"); Pkg.add("Pandas"); Pkg.add("DrWatson");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("DataFramesMeta"); Pkg.add("Flux"); Pkg.add("DataConvenience"); Pkg.add("RCall);'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("Dates"); Pkg.add("TimeSeries"); Pkg.add("StatsModels"); Pkg.add("NBInclude);'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("Measures"); Pkg.add("GR"); Pkg.add("FileIO"); Pkg.add("DecisionTrees"); Pkg.add("SpecialFunctions");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("Conda"); Pkg.add("DataStructures"); Pkg.add("Combinatorics"); Pkg.add("CategoricalArrays);'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("CSV"); Pkg.add("BSON"); Pkg.add("GraphRecipes"); Pkg.add("MLDatasets"); Pkg.add("MultiVariatStats");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.update();'

# adding iPython Clusters
ipcluster nbextension enable

#to reduce space
conda clean --all -f -y -q

#to make sure don't return with error from installing IJulia
echo 'done pre-configuration'
