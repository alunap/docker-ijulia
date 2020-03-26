# docker-ijulia

docker container for [IJulia Notebook][3]

"IJulia is a [Julia-language][6] backend combined with [Jupyter][8]. This combination allows you to interact with the Julia language using Jupyter/IPython's powerful [graphical notebook][9], which combines code, formatted text, math, and multimedia in a single document"

This notebook is for the last version in development for Julia if you are looking for the stable version I recomended that used the official docker image from Jupyter:  [jupyter/datascience-notebook][11]   and for more jupyter [docker-stacks][12]

## Install dependencies

  - [Docker][2]

To install docker in Ubuntu 18.04 use the commands:

    $ sudo apt-get update
    $ sudo wget -qO- https://get.docker.com/ | sh

 To install docker in other operating systems check [docker online documentation][4]

## Usage

To run container use the command below:

    $ docker run -d -p 8998:8998 --name ijulia quantumobject/docker-ijulia

Run the after install script:

    $ docker exec -it ijulia after_install

Need to provide new password.

## Accessing the IJulia applications:

After that check with your browser at addresses plus the port 8998:

  - **http://host_ip:8998/**
  
  and for experimental Jupyter lab : 
  
   - **http://host_ip:8998/lab/**

To access the container from the server running docker :

    $ docker exec -it ijulia /bin/bash

note: deploy this container behind proxy with SSL for extra security:

https://github.com/jwilder/nginx-proxy

https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion

## More Info

About [IJulia][3]

To help improve this container [docker-ijulia][5]

For additional info about us and our projects check our site [www.quantumobject.org][10]

[2]:https://www.docker.com
[3]:https://github.com/JuliaLang/IJulia.jl
[4]:http://docs.docker.com
[5]:https://github.com/QuantumObject/docker-ijulia
[6]:http://julialang.org
[7]:http://ipython.org
[8]:http://jupyter.org
[9]:http://ipython.org/notebook.html
[10]:https://www.quantumobject.org
[11]:https://github.com/jupyter/docker-stacks/tree/master/datascience-notebook
[12]:https://github.com/jupyter/docker-stacks
