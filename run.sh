#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

echo "Installing dependencies"
sudo apt -y install libmicrohttpd-dev libssl-dev build-essential libhwloc-dev screen

echo ">> Preparing environment"
sudo sysctl -w vm.nr_hugepages=128

sed -i "s@RIG_ID@$HOSTNAME@" $SCRIPTPATH/config.txt

echo ">> Cleaning potential previous instance"
if pgrep unicorn; then pkill unicorn || true; fi
if pgrep screen; then pkill screen || true; fi

echo ">> Running unicorn"

nice -n -19 screen -S "UNI_$HOSTNAME" -dm $SCRIPTPATH/unicorn

sleep 2

UNICORN_PROCESSES=$(pgrep unicorn)
# for i in $UNICORN_PROCESSES; do cpulimit -l 80 $i; done
for i in $UNICORN_PROCESSES; do renice -n -20 $i; done

sleep 2
if pgrep -x "unicorn" > /dev/null
then
  echo ">> Unicorn is now running!"
  exit 0
else
  echo ">> Unicorn failed to start /!\\"
  exit 1
fi
