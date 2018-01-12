#!/usr/bin/env bash

echo "-----------------------------------------"
echo "Installing dependencies"
echo "-----------------------------------------"

sudo apt -y install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev


echo "-----------------------------------------"
echo "Preparing environment"
echo "-----------------------------------------"

sudo sysctl -w vm.nr_hugepages=128


echo "-----------------------------------------"
echo "Running xmr stak cpu"
echo "-----------------------------------------"

CONFIG_XMR="config-electro.txt"
echo "XMR stak cpu configuration: " $CONFIG_XMR

screen -dm ./xmr-stak-cpu $CONFIG_XMR
