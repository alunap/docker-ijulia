#!/bin/bash

jupyter notebook --generate-config

julia -e 'Pkg.init(); Pkg.add("IJulia");Pkg.add("Cairo"); Pkg.add("PyPlot"); Pkg.add("SIUnits"); Pkg.add("Gadfly"); Pkg.add("DataStructures"); Pkg.add("HDF5"); Pkg.add("Iterators"); Pkg.add("MCMC"); Pkg.add("NumericExtensions"); Pkg.add("SymPy"); Pkg.add("Interact"); Pkg.add("Roots");'

julia -e 'Pkg.add("DataFrames"); Pkg.add("RDatasets"); Pkg.add("Distributions"); Pkg.add("Clustering"); Pkg.add("GLM"); Pkg.add("MCMC");'

julia -e 'Pkg.add("Optim"); Pkg.add("JuMP"); Pkg.add("GLPKMathProgInterface"); Pkg.add("Clp"); Pkg.add("NLopt"); Pkg.add("Ipopt");'

julia -e 'Pkg.add("Images"); Pkg.add("ImageView"); Pkg.add("WAV"); Pkg.add("ODE"); Pkg.add("Sundials"); Pkg.add("LinearLeastSquares");'

julia -e 'Pkg.add("BayesNets"); Pkg.add("PGFPlots"); Pkg.add("GraphLayout"); Pkg.add("Winston");'

julia -e 'Pkg.update();'

#remove because fail to install on Julia 0.5
#  Pkg.add("SVM");


# adding iPython Clusters
pip install ipyparallel
ipcluster nbextension enable

#to make sure don't return with error from installing IJulia
echo 'done pre-configuration'
