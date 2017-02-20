#!/bin/sh


d=$(python -c "from IPython.lib import passwd;a=passwd(); print(a)")
echo "c.NotebookApp.password = u'$d'" >>  /root/.jupyter/jupyter_notebook_config.py

date > /etc/secured
rm -f /sbin/after_install
