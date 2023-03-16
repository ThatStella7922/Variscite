# Variscite
Variscite is a tool that lets you easily inject a dylib into an IPA file.
This is usually used to modify apps for enhanced functionality or changing features.

## Usage
[Download Variscite.sh](https://github.com/ThatStella7922/Variscite/raw/master/Variscite.sh), then make it executable with `chmod +x Variscite.sh`.

See available arguments by running with `-h`.
```sh
./Variscite.sh -h
```

An example of quick usage in non-interactive mode is as follows:
```sh
./Variscite.sh -s1 -i/Users/Stella/Downloads/MyApp.ipa -d/Users/Stella/Downloads/MyDylib.dylib -o/Users/Stella/Desktop/
```

## Compatibility and Dependencies
Variscite is designed to be lightweight and as such uses standard bash-isms, with as few external binaries as possible. The only external dependencies are `curl` and [Azule](https://github.com/Al4ise/Azule), which Variscite installs during execution.

Variscite only requires the Command Line Tools on macOS, which should be installed for you if they are missing.
On Linux, Variscite should run on any sane distro (x86_64, and arm64 are supported), but this is untested.