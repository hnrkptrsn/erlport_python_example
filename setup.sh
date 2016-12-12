#!/bin/bash

python3 -m venv priv/erlpy3env

source priv/erlpy3env/bin/activate

OLDPATH=`pwd`

cd priv/python 

python setup.py build install

cd $OLDPATH/priv

# Fortune cookie dependency
git clone https://github.com/spasticVerbalizer/fortune.git

cd fortune

python setup.py build install

cd $OLDPATH

rebar3 shell

