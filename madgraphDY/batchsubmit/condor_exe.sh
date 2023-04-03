#!/bin/bash

#
# args
#

MASS=$1
FILEID=$2
NEVENTS=$3
NEVENTSTOTAL=$4
COPYDIR=$5

echo "[wrapper] MASS      = " ${MASS}
echo "[wrapper] FILEID    = " ${FILEID}
echo "[wrapper] NEVENTS   = " ${NEVENTS}
echo "[wrapper] NEVENTSTOTAL = " ${NEVENTSTOTAL}
echo "[wrapper] COPYDIR   = " ${COPYDIR}

echo
echo "[wrapper] uname -a:" `uname -a`

source /cvmfs/cms.cern.ch/cmsset_default.sh  > /dev/null 2>&1

export SCRAM_ARCH=slc7_amd64_gcc700
export CMSSW_VERSION=CMSSW_10_2_15

echo "[wrapper] SCRAM_ARCH" $SCRAM_ARCH
echo "[wrapper] CMSSW_VERSION" $CMSSW_VERSION

###version using cvmfs install of CMSSW
echo "[wrapper] setting env"
# source /cvmfs/cms.cern.ch/cmsset_default.sh
OLDDIR=`pwd`
cd /cvmfs/cms.cern.ch/$SCRAM_ARCH/cms/cmssw/$CMSSW_VERSION/src
#cmsenv
eval `scramv1 runtime -sh`
cd $OLDDIR

echo

echo "[wrapper] hostname  = " `hostname`
echo "[wrapper] date      = " `date`
echo "[wrapper] linux timestamp = " `date +%s`

#
# untar input sandbox
#

TMPDIR=tmp
mkdir $TMPDIR
mv input.tar.xz $TMPDIR
cd $TMPDIR

echo "[wrapper] extracting input sandbox"
tar -xJf input.tar.xz

echo "[wrapper] input contents are"
ls -a

#
# run it
#
echo "[wrapper] running: python write_cards_metis.py ${MASS} ${NEVENTS} ${FILEID}"
python write_cards_metis.py ${MASS} ${NEVENTS} ${FILEID}

echo "[wrapper] running: ./MG5_aMC_v2_6_7/bin/mg5_aMC cards//proc.dat"
./MG5_aMC_v2_6_7/bin/mg5_aMC cards//proc.dat

echo "[wrapper] running: python extract_kinematics_metis.py"
python extract_kinematics_metis.py

echo "[wrapper] running: ./ntupler/run -i ./cards/mgoutput/Events/run_01/mcp_p4s.txt -o output.root -N ${NEVENTSTOTAL} -e $((($FILEID-1)*$NEVENTS))"
./ntupler/run -i ./cards/mgoutput/Events/run_01/mcp_p4s.txt -o output.root -N ${NEVENTSTOTAL} -e $((($FILEID-1)*$NEVENTS))

#
# do something with output
#

echo "[wrapper] output is"
ls -lrth

#
# clean up
#

OUTFILE=output.root
if [ ! -e $OUTFILE ]; then
    echo "No output file, quitting!"
    exit 1
fi

echo "[wrapper] copying file"

if [ ! -d "${COPYDIR}" ]; then
    echo "creating output directory " ${COPYDIR}
    mkdir ${COPYDIR}
fi

substr="/ceph/cms"
COPYDIR_CEPH=${COPYDIR#$substr}
env -i X509_USER_PROXY=${X509_USER_PROXY} gfal-copy -p -f -t 4200 --verbose  --checksum ADLER32 file://`pwd`/$OUTFILE davs://redirector.t2.ucsd.edu:1095/${COPYDIR_CEPH}/output_${FILEID}.root

echo "[wrapper] cleaning up"
cd ../..
rm -r $TMPDIR
echo "[wrapper] cleaned up"
ls
