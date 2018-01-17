#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

CONFIG_XMR_STAK_CPU="config-sumo.txt"
if [[ ! -z "$1" ]] ; then
  CONFIG_XMR_STAK_CPU="$1"
fi

echo "Installing dependencies"
sudo apt -y install libmicrohttpd-dev libssl-dev build-essential libhwloc-dev cpulimit screen

echo ">> Preparing environment"
sudo sysctl -w vm.nr_hugepages=128

echo "> XMR stak cpu configuration: " $SCRIPTPATH/$CONFIG_XMR_STAK_CPU
sed -i "s@RIG_ID@$HOSTNAME@" $SCRIPTPATH/$CONFIG_XMR_STAK_CPU

echo ">> Running xmr stak cpu"

nice -n -19 screen -S "STAK_$HOSTNAME" -dm $SCRIPTPATH/xmr-stak-cpu $SCRIPTPATH/$CONFIG_XMR_STAK_CPU

STAKCPU_PROCESS=$(pgrep -o -x xmr-stak-cpu)
cpulimit -l 100 $STAKCPU_PROCESS
renice -n -20 $STAKCPU_PROCESS

sleep 2
if pgrep -x "xmr-stak-cpu" > /dev/null
then
  echo ">> XMR stak cpu is now running!"
else
  echo ">> XMR stak cpu failed to start /!\\"
fi
