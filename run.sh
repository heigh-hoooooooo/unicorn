#!/usr/bin/env bash

CONFIG_XMR_STAK_CPU="config-electro.txt"

echo "Installing dependencies"
sudo apt -y install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev

echo ">> Preparing environment"
sudo sysctl -w vm.nr_hugepages=128

echo ">> Running xmr stak cpu"
echo "> XMR stak cpu configuration: " $CONFIG_XMR_STAK_CPU

sed -i "s@RIG_ID@$HOSTNAME@" $CONFIG_XMR_STAK_CPU

screen -S "STAK_$HOSTNAME" -dm ./xmr-stak-cpu $CONFIG_XMR_STAK_CPU
