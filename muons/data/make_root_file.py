# Some weird stuff here that does not seem to work in python 3
# Also added the plot making at the end.
import sys
import numpy as np
import ROOT as r
import os
import matplotlib.pyplot as plt


fin = sys.argv[1]

data = []
pyVersion = sys.version_info[0]

if pyVersion == 2:
    with open(fin) as fid:
        for line in fid:
            if line.strip().startswith("#"):
                continue
            data.append(map(float, line.strip().split()))
        data = np.array(data)
else:
    data = np.loadtxt(fin)


pt = data[:,0]
cn = data[:,1]
up = data[:,3]
dn = data[:,2]

dpt = 0.1
new_pt = np.arange(dpt/2, 300-dpt/2+1e-12, dpt)
new_cn = np.exp(np.interp(new_pt, pt, np.log(cn)))
new_up = np.exp(np.interp(new_pt, pt, np.log(up)))
new_dn = np.exp(np.interp(new_pt, pt, np.log(dn)))

nbins = int(300/dpt)
h_cn = r.TH1D("central", ";p_{T}(#mu) [GeV]; dsigma / dpt [pb/GeV]", nbins, 0, 300)
h_up = r.TH1D("up", ";p_{T}(#mu) [GeV]; dsigma / dpt [pb/GeV]", nbins, 0, 300)
h_dn = r.TH1D("down", ";p_{T}(#mu) [GeV]; dsigma / dpt [pb/GeV]", nbins, 0, 300)

for i in range(new_cn.size):
    h_cn.SetBinContent(i+1, new_cn[i])
    h_up.SetBinContent(i+1, new_up[i])
    h_dn.SetBinContent(i+1, new_dn[i])

blah = input("Enter y if you want to save the root file  ")
if blah == 'y':
    print("Saving root file in ",  fin.replace(".txt",".root"))
    fout = r.TFile(fin.replace(".txt",".root"), "RECREATE")
    h_cn.Write()
    h_up.Write()
    h_dn.Write()
    fout.Close()
else:
    print("no root file for you")


# As a bonus, plot it as well
fig, ax = plt.subplots()
ax.plot(new_pt, new_up, linestyle='dashed', color='black',  label='up')
ax.plot(new_pt, new_cn, linestyle='solid',  color='black', label='central')
ax.plot(new_pt, new_dn, linestyle='dashed',  color='black', label='down')
ax.fill_between(new_pt, new_dn, new_up, color="lightblue")

ax.set_xlim(0, 300)
ax.tick_params("both", direction='in', length=10, right=True, top=True)
ax.tick_params("both", direction='in', length=7, right=True, which='minor')
ax.set_yscale('log')
ax.set_xlabel('Pt (Gev)', fontsize='xx-large')
ax.set_ylabel('d$\sigma$/dpt (pb/GeV)', fontsize='xx-large')

# File name with extension but without path
f1 = os.path.basename(fin)
# file name witout extension but with path
f2, _ = os.path.splitext(fin)
# file name without extension and without path
f3, _ = os.path.splitext(f1)

ax.set_title(f3, fontsize='xx-large')
ax.grid()
plt.yticks(fontsize='x-large')
plt.xticks(fontsize='x-large')
plt.tight_layout()
fig.show()

figFile = f2 + ".pdf" 
blah = input("Enter y if you want to save the plot in pdf to %s   " % figFile)
if blah == 'y':
    print("Saving plot in ", figFile)
    fig.savefig(figFile)
else:
    print("Plot not saved as pdf file")
