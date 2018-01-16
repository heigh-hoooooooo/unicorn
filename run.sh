#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

CONFIG_XMR_STAK_CPU="config-electro.txt"
if [[ ! -z "$1" ]] ; then
  CONFIG_XMR_STAK_CPU="$1"
fi

echo "Installing dependencies"
sudo apt -y install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev

echo ">> Preparing environment"
sudo sysctl -w vm.nr_hugepages=128

echo ">> Running xmr stak cpu"
echo "> XMR stak cpu configuration: " $SCRIPTPATH/$CONFIG_XMR_STAK_CPU

sed -i "s@RIG_ID@$HOSTNAME@" $SCRIPTPATH/$CONFIG_XMR_STAK_CPU

nice -n -18 screen -S "STAK_$HOSTNAME" -dm nice -n -20 $SCRIPTPATH/xmr-stak-cpu $SCRIPTPATH/$CONFIG_XMR_STAK_CPU
