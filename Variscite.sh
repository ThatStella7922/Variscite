#!/bin/bash

# ThatStella7922
ver="2023.314.1"

# colors
usecolors="true"
reset="\033[0m";faint="\033[37m";red="\033[38;5;196m";black="\033[38;5;244m";green="\033[38;5;46m";yellow="\033[38;5;226m";magenta="\033[35m";blue="\033[36m";default="\033[39m"
# formatting
bold="\033[1m";resetbold="\033[21m"
# message styling
init="${black}${faint}[${reset}${magenta}*${reset}${black}${faint}]${reset}"
info="${black}${faint}[${reset}${green}Info${reset}${black}${faint}]${reset}"
question="${black}${faint}[${reset}${yellow}?${reset}${black}${faint}]${reset}"
help="${black}${faint}[${reset}${green}?${reset}${black}${faint}]${reset}"
error="${black}${faint}[${reset}${red}${bold}Error${reset}${resetbold}${black}${faint}]${reset}"
warn="${black}${faint}[${reset}${yellow}!${reset}${black}${faint}]${reset}"
azule="${black}${faint}[${reset}${blue}Azule${reset}${black}${faint}]${reset}"
success="${black}${faint}[${reset}${green}√${reset}${black}${faint}]${reset}"
if [[ usecolors == "false" ]]; then
    reset="";faint="";red="";black="";green="";yellow="";magenta="";blue="";default=""
fi

# init message
echo -e "$init Variscite $ver"
echo -e "$init https://github.com/ThatStella7922/Variscite"
echo

### Functions
# downloadGh - Specify a URL when calling like "downloadGh https://test.com/file.txt"
downloadGh () {
    curl -LJO --progress-bar $1
    res=$?
    if test "$res" != "0"; then
        echo -e "$error curl failed with: $res"
        exit $res
    fi
}

installAzule () {
    echo -e "$info Downloading Azule..."
    rm -rf temp 2> /dev/null;mkdir temp;cd temp
    curl -LJ#o azule.zip https://github.com/Al4ise/Azule/archive/refs/heads/main.zip
    res=$?
    if test "$res" != "0"; then
        echo -e "$error curl failed with: $res"
        exit $res
    fi
    echo -e "$info Unpacking Azule..."
    unzip -q azule.zip;rm azule.zip
    echo -e "$info Installing Azule (this may require your password)..."
    if [[ ! -d ~/Applications ]]; then
        mkdir ~/Applications
    fi #check if applications folder exists at ~ so we can put Azule there
    if [[ -d ~/Applications/Azule-main ]]; then
        rm -rf ~/Applications/Azule-main
    fi #check if azule is there and if so delete it
    mv Azule-main/ ~/Applications/
    rm -rf temp
    sudo ln -sf ~/Applications/Azule-main/azule /usr/local/bin/azule
    if [[ $? == "0" ]]; then
        echo -e "$info Azule installed succesfully. (symlinked to /usr/local/bin/azule)"
    else
        echo -e "$error Installation failed with code $?"
        exit $?
    fi
}

uninstallAzule () {
    echo -e "$info Uninstalling Azule (this may require your password)..."
    if [[ -d ~/Applications/Azule-main ]]; then
        rm -rf ~/Applications/Azule-main
    fi #check if azule is there and if so delete it
    if [[ $? == "0" ]]; then
        echo -e "$info Deleted ~/Applications/Azule-main"
    else
        echo -e "$error Failed to remove ~/Applications/Azule-main, error code $?"
        exit $?
    fi
    sudo rm -rf /usr/local/bin/azule
    if [[ $? == "0" ]]; then
        echo -e "$info Azule uninstalled succesfully."
    else
        echo -e "$error Uninstallation failed with code $?"
        exit $?
    fi
}

# Checks for Azule and doesn't prompt for installation. Returns 1 if Azule not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveAzuleCheck () {
    if [[ ! -f "$(which azule)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
            echo -e "$error Cannot continue without Azule."
            echo -e "$info You can manually install it from https://github.com/Al4ise/Azule/wiki"
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

# Checks that the IPA is valid, returns 0 if OK and 1 if invalid.
# Call: validateIpa PathToIpa DoIPromptForNewIpa[true/false]
validateIpa () {
    if [[ "$1" != *".ipa" ]]; then
        if [[ $2 == "true" ]]; then
            read -p "$(echo -e "$question Specify the path of a valid IPA file: ")" ipafile
            validateIpa $ipafile true
        fi
        return 1
    else
        return 0
    fi
}

# Checks that the dylib is valid, returns 0 if OK and 1 if invalid.
# Call: validateDylib PathToDylib DoIPromptForNewDylib[true/false]
validateDylib () {
    if [[ "$1" != *".dylib" ]]; then
        if [[ $2 == "true" ]]; then
            read -p "$(echo -e "$question Specify the path of a valid dylib: ")" dylib
            validateDylib $dylib true
        fi
        return 1
    else
        return 0
    fi
}

# Checks that the folder exists, returns 0 if OK and 1 if it doesn't exist.
# Call: validatePath PathToCheck MakeFolderIfNotExist[true/false]
validatePath () {
    if [[ ! -d $1 ]]; then
        if [[ $2 == "true" ]]; then
            mkdir $1
            if [[ $? == "0" ]]; then
                return 0
            else
                echo -e "$error Folder creation at $1 failed."
                return 1
            fi
        else
            return 1
        fi
    else
        return 0
    fi
}

# Specify arguments when calling. patchIpa PathToIpa PathToDylib OutputPath
patchIpa () {
    azule -U -i $1 -o $3 -f $2 -r -v | sed -u -r "s/(\[\*\])/$(echo -e $azule)/g"
}

showHelp () {
    echo -e "$help Variscite is a tool that lets you easily inject a library (dylib) into an iOS app archive (IPA file)."
    echo -e "$help This is usually used to modify apps for enhanced functionality or changing features."
    echo -e "$help"
    echo -e "$help Variscite Arguments"
    echo -e "$help -h or --h   Show this help."
    echo -e "$help -iA or --iA Install Azule and exit. May prompt for password during sudo."
    echo -e "$help -uA or --uA Uninstall Azule and exit. May prompt for password during sudo."
    echo -e "$help"
    echo -e "$help -s1         Enable non-interactive mode. Requires specifying arguments."
    echo -e "$help -i[path]    Specify an IPA file. Example: -i/Users/Stella/Downloads/SomeApp.ipa"
    echo -e "$help -d[path]    Specify a dylib. Example: -d/Users/Stella/Downloads/SomeLibrary.dylib"
    echo -e "$help -o[path]    Specify an output path. Example: -o/Users/Stella/Downloads/"
    echo -e "$help"
    echo -e "$help Variscite Behavior"
    echo -e "$help If -s1 isn't passed, Variscite will run in interactive mode using options in -i, -d and -o."
    echo -e "$help If one of those three arguments wasn't passed, Variscite will prompt during execution."
    echo -e "$help"
    echo -e "$help If -s1 is passed, Variscite will run in non-interactive mode using options in -i, -d and -o."
    echo -e "$warn If any one of those three arguments is missing, Variscite will error out and exit."
    echo -e "$help"
    echo -e "$help Good to Know"
    echo -e "$warn If Azule isn't installed and -s1 is passed, Variscite will error out and exit."
}
### End of functions


## Start code
# Check for help argument
if [[ $1 == "-h"* ]] || [[ $1 == "--h"* ]]; then
    showHelp
    exit 0
fi

# Check for install Azule argument.
if [[ $1 == "-iA"* ]] || [[ $1 == "--iA"* ]]; then
    nonInteractiveAzuleCheck
    if [[ ! $? == "0" ]]; then
        installAzule
        exit $?
    else
        echo -e "$info Azule is already installed!"
    exit $?
    fi
fi

# Check for uninstall Azule argument.
if [[ $1 == "-uA"* ]] || [[ $1 == "--uA"* ]]; then
    nonInteractiveAzuleCheck
    if [[ $? == "0" ]]; then
        uninstallAzule
        exit $?
    else
        echo -e "$info Couldn't find Azule, it has likely already been uninstalled!"
    exit $?
    fi
fi

while getopts ':s:i:d:o:' OPTION
do
  case "${OPTION}" in
    s) silent=${OPTARG};;
    i) ipafile=${OPTARG};;
    d) dylib=${OPTARG};;
    o) outpath=${OPTARG};;
   \?) echo -e "$error Invalid option: -${OPTARG}" >&2; exit 1;;
    :) echo -e "$error option -${OPTARG} requires an argument" >&2; exit 1;;
  esac
done


# Non-interactive mode execution
if [[ $silent == "1" ]]; then
    echo -e "$init Running in non-interactive mode"
    if [[ -z $ipafile ]] || [[ -z $dylib ]] || [[ -z $outpath ]]; then
        echo -e "$error Missing arguments. Non-interactive mode cannot continue."
        echo -e "$info Specified IPA: $ipafile"
        echo -e "$info Specified dylib: $dylib"
        echo -e "$info Specified output path: $outpath"
        exit 1
    else
        nonInteractiveAzuleCheck true
        if [[ $? == "0" ]]; then
            validateIpa $ipafile;iparesult=$?
            validateDylib $dylib;dylibresult=$?
            validatePath $outpath;pathresult=$?
            # check if all passed files and paths are valid
            if [[ $iparesult == "1" ]] || [[ $dylibresult == "1" ]] || [[ $pathresult == "1" ]]; then
                echo -e "$error One of the selected input files or output path is bad."
                echo -e "$info Specified IPA: $ipafile - Bad: $iparesult"
                echo -e "$info Specified dylib: $dylib - Bad: $dylibresult"
                echo -e "$info Specified output path: $outpath - Bad: $pathresult"
                exit 1
            else
                echo -e "$info Running Azule now..."
                patchIpa $ipafile $dylib $outpath
                if [[ $? == "0" ]]; then
                    echo -e "$success Azule finished patching the IPA file"
                    exit 0
                else
                    echo -e "$error SHITS FUCKED"
                    exit 1
                fi
            fi
        else
            # Error message from no Azule was triggered in the above call to nonInteractiveAzuleCheck
            exit
        fi
    fi
fi


# Interactive mode execution
# Check for azule
if [ ! -f "$(which azule)" ]; then
    echo -e "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
    echo -e "$question Variscite can download and install Azule if you want to."
    read -p "$(echo -e "$question Install Azule? y/n: ")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]];then
        installAzule
    else
        echo -e "$error Cannot continue without Azule."
        echo -e "$info You can manually install it from https://github.com/Al4ise/Azule/wiki"
        exit 1
    fi
fi

echo -e "$init Interactive mode is currently not implemented. Please run with -h for help with non-interactive mode."