#!/bin/bash

# Install conda
 mkdir -p $CONDA_DIR
 echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh
 wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
 /bin/bash /Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR
 rm Miniconda3-latest-Linux-x86_64.sh

conda create -n conda_jl python
julia -e 'using Pkg ; Pkg.init() ; Pkg.add("Conda") ; Pkg.build("Conda") ; '

conda install --yes jupyter ipywidgets pandas matplotlib \
scipy seaborn scikit-learn scikit-image sympy cython patsy statsmodels cloudpickle dill numba bokeh

ln -s /opt/conda/pkgs/zeromq-4.0.*/lib/libzmq.so.4.* /opt/conda/lib/libzmq.so.4 
ln -s /opt/conda/pkgs/libsodium-0.4.*/lib/libsodium.so.4.* /opt/conda/lib/libsodium.so.4

# Ipopt
mkdir ipopt; cd ipopt; wget  http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.10.tgz
tar -xzf Ipopt-3.12.10.tgz; cd Ipopt-3.12.10
cd ThirdParty/Blas; ./get.Blas; ./configure --prefix=/usr/local --disable-shared --with-pic; make install; cd ../..
cd ThirdParty/Lapack; ./get.Lapack; ./configure --prefix=/usr/local --disable-shared --with-pic; make install; cd ../..
cd ThirdParty/Mumps; ./get.Mumps; cd ../..
./configure --prefix=/usr/local --enable-dependency-linking --with-blas=/usr/local/lib/libcoinblas.a --with-lapack=/usr/local/lib/libcoinlapack.a
make install 
echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf; ldconfig
cd ../.. 
rm -rf ipopt

# Cbc
mkdir cbc; cd cbc; wget http://www.coin-or.org/download/source/Cbc/Cbc-2.9.9.tgz
tar -xzf Cbc-2.9.9.tgz; cd Cbc-2.9.9
./configure --prefix=/usr/local --enable-dependency-linking --without-blas --without-lapack --enable-cbc-parallel
make install
echo "/usr/local/lib" > /etc/ld.so.conf.d/cbc.conf; ldconfig
cd ../..
rm -rf cbc

jupyter notebook --generate-config

JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("IJulia");Pkg.add("Cairo"); Pkg.add("PyPlot"); Pkg.add("SIUnits"); Pkg.add("Gadfly"); Pkg.add("DataStructures"); Pkg.add("HDF5"); Pkg.add("Iterators"); Pkg.add("MCMC"); Pkg.add("NumericExtensions"); Pkg.add("SymPy"); Pkg.add("Interact"); Pkg.add("Roots");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("DataFrames"); Pkg.add("RDatasets"); Pkg.add("Distributions"); Pkg.add("Clustering"); Pkg.add("GLM"); Pkg.add("MCMC");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("Optim"); Pkg.add("JuMP"); Pkg.add("GLPKMathProgInterface"); Pkg.add("Clp"); Pkg.add("NLopt"); Pkg.add("Ipopt");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("Images"); Pkg.add("ImageView"); Pkg.add("WAV"); Pkg.add("ODE"); Pkg.add("Sundials"); Pkg.add("LinearLeastSquares");'
JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.add("BayesNets"); Pkg.add("PGFPlots"); Pkg.add("GraphLayout"); Pkg.add("Winston");'
# JUPYTER=$(which jupyter) julia -e 'using Pkg ; Pkg.update();'

# adding iPython Clusters
pip install ipyparallel
ipcluster nbextension enable

#to reduce space
conda clean -yt

#to make sure don't return with error from installing IJulia
echo 'done pre-configuration'
