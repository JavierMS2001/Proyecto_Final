#!/bin/bash

python3 -m pip uninstall ansible -y > /dev/null

sudo yum remove python3 python36 ansible -y > /dev/null

sudo dnf update -y && sudo dnf upgrade -y > /dev/null

sudo yum install wget -y > /dev/null

sudo yum install libffi-devel gcc yum-utils zlib-devel python-tools cmake git pkgconfig -y --skip-broken > /dev/null

sudo yum groupinstall -y "Development Tools" --skip-broken > /dev/null

wget https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz

tar xzf "Python-3.11.3.tgz"

cd "Python-3.11.3/" && ./configure && make && make install

python3.11 -m pip install --upgrade pip

