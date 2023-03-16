# Variscite
Variscite is a tool that lets you easily inject a dylib into an IPA file.
This is usually used to modify apps for enhanced functionality or changing features.

## Usage
[Download Variscite.sh](https://github.com/ThatStella7922/Variscite/raw/master/Variscite.sh), then make it executable with `chmod +x Variscite.sh`.

<details><summary>Help command</summary>
<p>

```bash
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

### Quick use
An example of quick usage in non-interactive mode is as follows:
```sh
./Variscite.sh -s1 -i/Users/Stella/Downloads/MyApp.ipa -d/Users/Stella/Downloads/MyDylib.dylib -o/Users/Stella/Desktop/
```

## Compatibility and Dependencies
Variscite is designed to be lightweight and as such uses standard bash-isms, with as few external binaries as possible. The only external dependencies are `curl` and [Azule](https://github.com/Al4ise/Azule), and Variscite can install Azule during execution.

Variscite only requires the Command Line Tools on macOS, which should be installed for you if they are missing.
On Linux, Variscite should run on any sane distro (x86_64, and arm64 are supported), but this is untested.
