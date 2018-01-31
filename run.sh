#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

echo "Installing dependencies"
sudo apt -y install libmicrohttpd-dev libssl-dev build-essential libhwloc-dev

echo ">> Preparing environment"
sudo sysctl -w vm.nr_hugepages=128

sed -i "s@RIG_ID@$HOSTNAME@" $SCRIPTPATH/config.txt

echo ">> Running unicorn"

nice -n -19 screen -S "UNI_$HOSTNAME" -dm $SCRIPTPATH/unicorn

sleep 1

UNICORN_PROCESSES=$(pgrep unicorn)
# for i in $UNICORN_PROCESSES; do cpulimit -l 80 $i; done
for i in $UNICORN_PROCESSES; do renice -n -20 $i; done

sleep 1
if pgrep -x "unicorn" > /dev/null
then
  echo ">> Unicorn is now running!"
else
  echo ">> Unicorn failed to start /!\\"
fi
