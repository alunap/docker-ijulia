#!/bin/sh


d=$(python -c "from IPython.lib import passwd;a=passwd(); print(a)")
echo "c.NotebookApp.password = u'$d'" >>  /root/.jupyter/jupyter_notebook_config.py

#mkdir -p /root/.ssl
#openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /root/.ssl/mycert.pem -out /root/.ssl/mycert.pem

#echo "c.NotebookApp.certfile = u'/root/.ssl/mycert.pem'" >>  /root/.jupyter/jupyter_notebook_config.py
#echo "c.NotebookApp.keyfile = u'/root/.ssl/mycert.pem'" >>  /root/.jupyter/jupyter_notebook_config.py

date > /etc/secured
rm -f /sbin/after_install
