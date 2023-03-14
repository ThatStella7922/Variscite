#!/bin/sh

# ThatStella7922
ver="2023.314.0"

# colors
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

# init message
echo "$init Variscite $ver"
echo "$init https://github.com/ThatStella7922/Variscite"
echo

### Functions
# downloadGh - Specify a URL when calling like "downloadGh https://test.com/file.txt"
downloadGh () {
    curl -LJO --progress-bar $1
    res=$?
    if test "$res" != "0"; then
        echo "$error curl failed with: $res"
        exit $res
    fi
}

installAzule () {
    echo "$info Downloading Azule..."
    rm -rf temp 2> /dev/null;mkdir temp;cd temp
    curl -LJ#o azule.zip https://github.com/Al4ise/Azule/archive/refs/heads/main.zip
    res=$?
    if test "$res" != "0"; then
        echo "$error curl failed with: $res"
        exit $res
    fi
    echo "$info Unpacking Azule..."
    unzip -q azule.zip;rm azule.zip
    echo "$info Installing Azule (this may require your password)..."
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
        echo "$info Azule installed succesfully. (symlinked to /usr/local/bin/azule)"
    else
        echo "$error Installation failed with code $?"
        exit $?
    fi
}

uninstallAzule () {
    echo "$info Uninstalling Azule (this may require your password)..."
    if [[ -d ~/Applications/Azule-main ]]; then
        rm -rf ~/Applications/Azule-main
    fi #check if azule is there and if so delete it
    if [[ $? == "0" ]]; then
        echo "$info Deleted ~/Applications/Azule-main"
    else
        echo "$error Failed to remove ~/Applications/Azule-main, error code $?"
        exit $?
    fi
    sudo rm -rf /usr/local/bin/azule
    if [[ $? == "0" ]]; then
        echo "$info Azule uninstalled succesfully."
    else
        echo "$error Uninstallation failed with code $?"
        exit $?
    fi
}

# Checks for Azule and doesn't prompt for installation. Returns 1 if Azule not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveAzuleCheck () {
    if [[ ! -f "$(which azule)" ]]; then
        if [[ $1 == "true" ]]; then
            echo "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
            echo "$error Cannot continue without Azule."
            echo "$info You can manually install it from https://github.com/Al4ise/Azule/wiki"
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
            read -p "$(echo "$question Specify the path of a valid IPA file: ")" ipafile
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
            read -p "$(echo "$question Specify the path of a valid dylib: ")" dylib
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
                echo "$error Folder creation at $1 failed."
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
    azule -U -i $1 -o $3 -f $2 -r -v | sed -u -r "s/(\[\*\])/$(echo $azule)/g"
}

showHelp () {
    echo "$help Variscite is a tool that lets you easily inject a library (dylib) into an iOS app archive (IPA file)."
    echo "$help This is usually used to modify apps for enhanced functionality or changing features."
    echo "$help"
    echo "$help Variscite Arguments"
    echo "$help -h or --h   Show this help."
    echo "$help -iA or --iA Install Azule and exit. May prompt for password during sudo."
    echo "$help -uA or --uA Uninstall Azule and exit. May prompt for password during sudo."
    echo "$help"
    echo "$help -s1         Enable non-interactive mode. Requires specifying arguments."
    echo "$help -i[path]    Specify an IPA file. Example: -i/Users/Stella/Downloads/SomeApp.ipa"
    echo "$help -d[path]    Specify a dylib. Example: -d/Users/Stella/Downloads/SomeLibrary.dylib"
    echo "$help -o[path]    Specify an output path. Example: -o/Users/Stella/Downloads/"
    echo "$help"
    echo "$help Variscite Behavior"
    echo "$help If -s1 isn't passed, Variscite will run in interactive mode using options in -i, -d and -o."
    echo "$help If one of those three arguments wasn't passed, Variscite will prompt during execution."
    echo "$help"
    echo "$help If -s1 is passed, Variscite will run in non-interactive mode using options in -i, -d and -o."
    echo "$warn If any one of those three arguments is missing, Variscite will error out and exit."
    echo "$help"
    echo "$help Good to Know"
    echo "$warn If Azule isn't installed and -s1 is passed, Variscite will error out and exit."
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
        echo "$info Azule is already installed!"
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
        echo "$info Couldn't find Azule, it has likely already been uninstalled!"
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
   \?) echo "$error Invalid option: -${OPTARG}" >&2; exit 1;;
    :) echo "$error option -${OPTARG} requires an argument" >&2; exit 1;;
  esac
done


# Non-interactive mode execution
if [[ $silent == "1" ]]; then
    echo "$init Running in non-interactive mode"
    if [[ -z $ipafile ]] || [[ -z $dylib ]] || [[ -z $outpath ]]; then
        echo "$error Missing arguments. Non-interactive mode cannot continue."
        echo "$info Specified IPA: $ipafile"
        echo "$info Specified dylib: $dylib"
        echo "$info Specified output path: $outpath"
        exit
    else
        nonInteractiveAzuleCheck true
        if [[ $? == "0" ]]; then
            validateIpa $ipafile;iparesult=$?
            validateDylib $dylib;dylibresult=$?
            validatePath $outpath;pathresult=$?
            # check if all passed files and paths are valid
            if [[ $iparesult == "1" ]] || [[ $dylibresult == "1" ]] || [[ $pathresult == "1" ]]; then
                echo "$error One of the selected input files or output path is bad."
                echo "$info Specified IPA: $ipafile - Bad: $iparesult"
                echo "$info Specified dylib: $dylib - Bad: $dylibresult"
                echo "$info Specified output path: $outpath - Bad: $pathresult"
                exit
            else
                echo "$info Running Azule now..."
                patchIpa $ipafile $dylib $outpath
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
    echo "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
    echo "$question Variscite can download and install Azule if you want to."
    read -p "$(echo "$question Install Azule? y/n: ")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]];then
        installAzule
    else
        echo "$error Cannot continue without Azule."
        echo "$info You can manually install it from https://github.com/Al4ise/Azule/wiki"
        exit 1
    fi
fi

echo "$init Interactive mode is currently not implemented. Please run with -h for help with non-interactive mode."