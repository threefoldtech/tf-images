#!/bin/bash

apt upgrade -y
apt install curl gnupg2 nginx-full -y
apt install apt-transport-https -y
apt install software-properties-common -y 
apt-add-repository universe -y
apt install openjdk-11-jdk -y
apt update
