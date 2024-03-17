# Computer Organization and Assembly Language

## Quick install (requires Linux or WSL)
1. Please install a Docker-compatible OCI tool (Podman OK, sub `podman` for `docker`)
2. For Docker, execute `docker run -it fedora` (install commands assume `dnf` exists)
3. Execute `dnf install g++ nasm git -y && git clone https://github.com/sahicken/cpsc240.git`
4. Execute `cd assns` and `cd $NUMBER` to select an assignment, replacing $NUMBER
5. To run an assignment normally run `./r.sh`, and for debug `./rg.sh` (only if rg.sh exists)
