# ctrlp-locate
grep your source code via ctrlp.vim!

# Installation
- use your favorite method.
````
Plug 'ompugao/ctrlp-grep'
Bundle 'ompugao/ctrlp-grep'
NeoBundle 'ompugao/ctrlp-grep'
````
- and install silversearcher-ag.

# Usage
- call command:
````
cd ~/.vim/bundle/ctrlp.vim
vim
:CtrlPGrep<CR>
````
- there will be no entry. it's fine.
- and then, input whatever word you want to search. for example:
````
>>> ctrlpmru
````
- wait a little bit...
````
> doc/ctrlp.txt:1678:22:    + New command: |:CtrlPMRU|
> doc/ctrlp.txt:885:2::CtrlPMRU
> doc/ctrlp.txt:884:71:                                                                    *:CtrlPMRU*
> autoload/ctrlp/mrufiles.vim:148:6:    aug CtrlPMRUF
> readme.md:16:27:* Run `:CtrlPBuffer` or `:CtrlPMRU` to invoke CtrlP in find buffer or find MRU file mode.
> doc/ctrlp.cnx:1566:20:    + 新命令: |:CtrlPMRU|
> doc/ctrlp.cnx:829:2::CtrlPMRU
> doc/ctrlp.cnx:828:71:                                                                    *:CtrlPMRU*
> plugin/ctrlp.vim:21:20:com! -n=? -com=dir CtrlPMRUFiles cal ctrlp#init('mru', { 'dir': <q-args> })
````
- Yes! select whatever you want to open!
  
# Configuration
- see doc/ctrlp-grep.txt 

# LICENSE
MIT
