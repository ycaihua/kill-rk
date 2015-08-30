# kill-rk
## userland Azazel and Jynx2 rootkit removal script
this script is designed to remove Azazel and Jynx2 from the system. the script utilizes very simple flaws in the rootkits</br>
and uses the flaws to bypass the rootkit file protections.
</br>
</br>
# how does it work
it's rather simple really.</br>
## azazel
Azazel comes with a flaw that allows a user to call symlink() on any protected rootkit files. by utilizing this flaw, we can bypass</br>
basic file protection, allowing us to read from files and write to them to. the script creates a temporary symbolic link to ld.so.preload</br>
in /tmp, then writes a temporary value to ld.so.preload so that the rootkit's shared object file is no longer being loaded. it then proceeds</br>
to remove other miscallenous rootkit files, and copies the shared object file to /tmp.</br>
## jynx2
unlike Azazel, this presented some issues. since Jynx2 uses magic GIDs to hide the majority of rootkit files and directories, we can't just</br>
use a symlink() vulnerability. we have to utilize the previously existing reality.so library that Jynx2 installs in its installation directory</br>
in order to temporarily bypass rootkit file protection. this more or less works the same as the Azazel removal part of the script, except this</br>
time we need to use reality.so. this option also copies both jynx2.so and reality.so to /tmp.</br>
