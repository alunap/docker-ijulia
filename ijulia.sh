#!/bin/sh
### In ijulia.sh (make sure this file is chmod +x):
# `/sbin/setuser xxxxx` runs the given command as the user `xxxxxx`.
# If you omit that part, the command will be run as root.

set -e

export HOME=/root
cd /root



if [ -f /etc/secured ]; then
        echo 'already secured'
        exec jupyter notebook
else
        echo 'need to secured by running docker exec -it container_id after_install to be able to used it'
        echo 'need to secured by running docker exec -it container_id after_install to be able to used it' >> /var/log/ijulia.log 2>&1
fi

