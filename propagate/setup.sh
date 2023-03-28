#! /bin/bash

if [ ! -d MilliqanSim ]; then
    # git clone https://github.com/bjmarsh/MilliqanSim.git
    git clone https://github.com/claudiocc1/MilliqanSim.git
fi

pushd MilliqanSim
. setup.sh
popd


