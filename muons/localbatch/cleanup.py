import os

tag = "A2-MSTW2008LO"

base_dir="/ceph/cms/store/user/fsetti/milliQan_generation/muons/"

names = {"qcd":1,"w":2,"dy":3,"qcd_nonbc":4}

for proc in names.keys()):
    outdir = os.path.join(base_dir,tag,proc)
    os.system("rm -rf %s/logs"%(outdir))
