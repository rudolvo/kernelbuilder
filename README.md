# veux-kernelbuilder

## Build using Actions
1. Fork this repo
2. Settings tab > Actions > General > Allow all actions and reusable workflows > Save
3. Actions tab > Run workflow
   - If you want to integrate KernelSU in the build, uncomment `KSU=1` in `build.sh`
4. Download the artifact. Flash it with your custom recovery
  
## Build on local host
`git clone https://github.com/cachiusa/veux-kernelbuilder`

`./build.sh`
### Usage for `build.sh`:
- (leave empty)  => run everything from start to end
- `KSU=1 ./build.sh` => same, but integrates KernelSU
- `getsource`/`gettools`/`startbuild`/`finalize` => run a specific section of build process

