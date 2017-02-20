#name of container: docker-ijulia-notebook
#versison of container: 0.5.6
FROM quantumobject/docker-baseimage:15.10
MAINTAINER Angel Rodriguez  "angel@quantumobject.com"

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN echo "deb http://ppa.launchpad.net/staticfloat/juliareleases/ubuntu `cat /etc/container_environment/DISTRIB_CODENAME` main " >> /etc/apt/sources.list  \
    && echo "deb http://ppa.launchpad.net/staticfloat/julia-deps/ubuntu `cat /etc/container_environment/DISTRIB_CODENAME` main" >> /etc/apt/sources.list  \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D3D3ACC 
RUN apt-get update && apt-get install -y -q --no-install-recommends apt-utils \
                    git \
                    build-essential \
                    bzip2 \
                    unzip \
                    libcairo2 \
                    libcairo2-dev \
                    libpango-1.0-0 glib2.0 \
                    file \
                    python3 \
                    python3-dev  \
                    ca-certificates \
                    libsm6 \
                    pandoc \
                    texlive-latex-base \
                    texlive-latex-extra \
                    texlive-fonts-extra \
                    texlive-fonts-recommended \
                    libxrender1 \
                    gfortran \
                    gcc \
                    fonts-dejavu \
                    julia \
                    libpng12-dev \
                    libglib2.0-dev \
                    librsvg2-dev \
                    libpixman-1-dev \
                    hdf5-tools \
                    glpk-utils \
                    libnlopt0 \
                    imagemagick \
                    inkscape \
                    gettext \
                    libreadline-dev \
                    libncurses-dev \
                    libpcre3-dev \
                    libgnutls28-dev \
                    tmux \
                    pkg-config \
                    pdf2svg \
                    libc6 \
                    libc6-dev \
                    python-distribute \
                    python3-software-properties \
                    software-properties-common \
                    python3-setuptools \
                    python3-yaml \
                    python-m2crypto \
                    python-poppler \
                    python3-crypto \
                    python3-msgpack \
                    libffi-dev \
                    libssl-dev \
                    libzmq3-dev \
                    python3-pip \
                    python3-zmq \
                    python3-jinja2 \
                    python3-requests \
                    python3-numpy \
                    python3-isodate \
                    libsundials-cvode1 \
                    libsundials-cvodes2 \
                    libsundials-ida2 \
                    libsundials-idas0 \
                    libsundials-kinsol1 \
                    libsundials-nvecserial0 \
                    libsundials-serial \
                    libsundials-serial-dev \
                    libnlopt-dev \
                    openmpi-bin \
                    libopenmpi-dev \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*
                    

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash

#provisional ... 
RUN ln -s  /usr/lib/libgettextlib-0.19.4.so /usr/lib/libgettextlib.so

# Install conda
# https://repo.continuum.io/miniconda/Miniconda3-4.3.11-Linux-x86_64.sh
# https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-latest-Linux-x86_64.sh
                    
# Install Jupyter notebook and python 3 packages ....
RUN conda install --yes jupyter \
    ipywidgets pandas matplotlib \
    scipy seaborn scikit-learn scikit-image sympy \
    cython patsy statsmodels cloudpickle \
    dill numba bokeh \
    && conda clean -yt

# WORKAROUND: symlink version of zmq required by latest rzmq back into conda lib
# https://github.com/jupyter/docker-stacks/issues/55
RUN ln -s /opt/conda/pkgs/zeromq-4.0.*/lib/libzmq.so.4.* /opt/conda/lib/libzmq.so.4 
RUN ln -s /opt/conda/pkgs/libsodium-0.4.*/lib/libsodium.so.4.* /opt/conda/lib/libsodium.so.4
    
##startup scripts  
#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

##Adding Deamons to containers
RUN mkdir /etc/service/ijulia
COPY ijulia.sh /etc/service/ijulia/run
RUN chmod +x /etc/service/ijulia/run

#pre-config scritp for different service that need to be run when container image is create 
#maybe include additional software that need to be installed ... with some service running ... like example mysqld
COPY pre-conf.sh /sbin/pre-conf
RUN chmod +x /sbin/pre-conf  ; sync \
    && /bin/bash -c /sbin/pre-conf \
    && rm /sbin/pre-conf

#add files and script that need to be use for this container
#include conf file relate to service/daemon 
#additionsl tools to be use internally 
COPY after_install.sh /sbin/after_install
RUN chmod +x /sbin/after_install

# to allow access from outside of the container  to the container service
# at that ports need to allow access from firewall if need to access it outside of the server. 
EXPOSE 8998

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
