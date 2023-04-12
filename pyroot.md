## PYROOT
Begin with `from ROOT import *`

##### Load TTree
```
file = TFile.Open(FileName)
tree = file.get(TreeName)
file.Close()
```
+ `Open` DOES NOT support `with` method.
+ Call `tree` after closing `file` will run out the kernel.

##### Load TChain
```
chain = TChain(TreeName)
for i in FileList:
    chain.AddFile(i)
```

##### Load TBranch
```
tree.GetEntries() # Get total entries number
tree.GetEntry(1) # ?
tree.Show(0) # see 0-th entry

for branch in tree/chain:
  a = branch.leaf
  b = getattr(branch, LeafName)
  # do sth to branch
```

##### with uproot
If the structure is flatten
```
with uproot.open(filename) as h:
    B1 = h[TreeName][BranchName].array(library='np')
```
It will return an awkward array by default,  if complex.
