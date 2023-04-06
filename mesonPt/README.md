Code to obtain cross sections and pT distributions for pi0, rho,
omega, phi, eta, etaprime production, as well as muons from pi/K
decays and from heavy flavor (Heavy flavor muons however should be
taken from the ../muon folder).

The distributions are stored in `pt_dists*.root`, (see comment at the end). y-axis units are
"particles per minbias event per 50 MeV bin in abs(eta)<2".
So, the total cross section for a given particle is the sum of all bin
contents ("particles per minbias event in abs(eta)<2")
times the MinBias cross section (CMS recommends 69.2 mb @ 13 TeV, for demonstrator paper we ended up using 80 mb found by ATLAS and various tools).

This was originally done using CMS MC samples (Summer16, with TuneCUETP8M1).
To avoid using CMS samples for non-CMS work, this was duplicated in standalone pythia
using the public tune. The two methods were verified to give identical results.
Instructions for running both are below.

**Note:** for phi meson production, we decided to use the DW tune in pythia6 as this was found to best reproduced experimental measurements. pythia6 is fortran-based, so requires some extra work. Franny Setti implemented this, with scripts in the `pythia6` directory. The output of this is a histogram just like produced in the pythia8 steps below, which can be fed into `stitch.py`.

To run over CMS MC samples using a CMSSW analyzer:
```
cmsrel CMSSW_9_4_14
cp -r looper CMSSW_9_4_14/src
cd CMSSW_9_4_14/src
eval `scramv1 runtime -sh`
scram b -j12
cd looper/looper/python
cmsRun test_cfg.py
```

To run with a standalone pythia program:
```
cd pythia
. setup.sh  # this will download and compile pythia if it hasn't been done yet
make
./main <mode> <tune> <n_events>  # mode = 0 (minbias), 1, 2, 3 (qcd pT-binned 15to30, 30to50, 50to80)
```

Possible tunes are 0 for Monash2013, 1 for CUETP8M1, 7 for A2-CTEQ6L1, and 8 for A2-MSTW2008LO.

Tools for batch submission are in `looper/looper/batchsubmit` or `pythia/batchsubmit`.

Once done with either method, `hadd` all output files somewhere. 
The script `stitch.py` makes stitched histograms for all particles, in
`pt_dists*.root`.

The current `pt_dists.root` file is directly copied from Bennett's old
repository, and it likely contains a bugged pt distribution for the
phi meson. The corrected meson pt distributions for Run 3 (Run 2) are
stored in `pt_dists_run3.root` (`pt_dists_run2.root`) and use Pythia 8
Monash2013 Tune for all mesons except for phi mesons which are
modelled with Pythia 6 DW Tune.  Ratio of Pt distributions between the
new (Run 3) and old (Run 2, Bennett's repository) meson Pt
distributions
are displayed in `mesons_run3_vs_run2.pdf`.  Finally, `mesons_run3_vs_run2.pdf`
has Pr distributions for pi/K decays (Run 3) and a Run 3 to Run 2 comparison. 
