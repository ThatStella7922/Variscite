# Variscite
Variscite is a tool that lets you easily inject a dylib into an IPA file.
This is usually used to modify apps for enhanced functionality or changing features.

## Installation
Head to the [Releases page](https://github.com/ThatStella7922/Variscite/releases) for a download and instructions for how to use it.

<!-- Alternatively, you can run Variscite one-time with the following command in a terminal:
```sh
curl -LJ https://github.com/ThatStella7922/Variscite/raw/master/Variscite.sh | bash
```
-->

## Usage
Running Variscite with no arguments will start interactive mode, which will prompt you for the IPA, dylib and output path. With proper arguments, you can also run Variscite in non-interactive mode. 

### Quick use
An example of quick usage in non-interactive mode is as follows:
```sh
./Variscite.sh -s1 -i/Users/Stella/Downloads/MyApp.ipa -d/Users/Stella/Downloads/MyDylib.dylib -o/Users/Stella/Desktop/
```

### Full help
You can run Variscite with the `-h` argument to get the full help, or you can click below to view it right here.
<details><summary>Click to expand</summary>
<p>

```
./Variscite.sh -h 
[*] Variscite 2023.315.1
[*] https://github.com/ThatStella7922/Variscite

[?] Variscite is a tool that lets you easily inject a library (dylib) into an iOS app archive (IPA file).
[?] This is usually used to modify apps for enhanced functionality or changing features.
[?]
[?] Variscite Arguments
[?] -h or --h   Show this help.
[?] -iA or --iA Install Azule and exit. May prompt for password during sudo.
[?] -uA or --uA Uninstall Azule and exit. May prompt for password during sudo.
[?]
[?] -s1         Enable non-interactive mode. Requires specifying arguments.
[?] -i[path]    Specify an IPA file. Example: -i/Users/Stella/Downloads/SomeApp.ipa
[?] -d[path]    Specify a dylib. Example: -d/Users/Stella/Downloads/SomeLibrary.dylib
[?] -o[path]    Specify an output path. Example: -o/Users/Stella/Downloads/
[?]
[?] Variscite Behavior
[?] If -s1 isn't passed, Variscite will run in interactive mode using options in -i, -d and -o.
[?] If one of those three arguments wasn't passed, Variscite will prompt during execution.
[?]
[?] If -s1 is passed, Variscite will run in non-interactive mode using options in -i, -d and -o.
[!] If any one of those three arguments is missing, Variscite will error out and exit.
[?]
[?] Good to Know
[!] If Azule isn't installed and -s1 is passed, Variscite will error out and exit.
```

</p>
</details>

## Compatibility and Dependencies
Variscite is designed to be lightweight, only relying on bash and a few external binaries.

Variscite uses [Azule](https://github.com/Al4ise/Azule) for IPA patching - which is automatically downloaded and installed as needed!

### macOS
Variscite requires the Xcode Command Line Tools on macOS, which will be installed for you if they're missing.

### Other OSes
On other OSes, Variscite *should(?)* work if your OS has `git`, `unzip` and optionally `curl` at the command line. Azule might require additional dependencies, but I'm not sure.

### Jailbroken iOS
Variscite can technically run on iOS/iPadOS/tvOS/whatever, but due to the differences between rootless/rootful/fakefs jailbreaks I am explicitly disallowing running on iOS.

I write a symlink to /usr/local/bin and this is not doable on rootless jailbroken iOS (i think), so instead of having a simple warning for rootless users and potentially bricking people's devices if they can't read, I'm just making it so that Variscite will not run on *any* jailbroken iOS.

If you know what you're doing and are OK with zero support in the case of an unbootable device, you can modify the `installAzule` and `uninstallAzule` functions, then remove the check that exits with code 1 when running on iOS. 