#!/bin/bash
set -e

if [ "$1" = 'start' ]; then
  service mysql start
  service ntp start
  service ssh start
  systemctl start supervisord
  systemctl start cloudera-scm-server
  systemctl start cloudera-scm-agent

  exec tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log
fi

exec "$@"