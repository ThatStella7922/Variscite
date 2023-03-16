#!/bin/bash

# Variscite Functions_Test - by ThatStella7922
# Shoutout to crystall1nedev, my beloved
ver="2023.315.1"

##################################################################################################
##################################################################################################
####                                                                                          ####
####   This is a testing file. Commands will be added and removed at random from this file.   ####
####                                                                                          ####
##################################################################################################
##################################################################################################

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
echo -e "$init Variscite Functions_Test $ver"
echo -e "$init https://github.com/ThatStella7922/Variscite"
echo

### Functions
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

# Checks for curl and doesn't prompt for installation. Returns 1 if curl not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveCurlCheck () {
    if [[ ! -f "$(which curl)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate curl. If it's already installed, make sure that it's in the PATH."
            echo -e "$error Cannot continue without curl."
            echo -e "$info curl should be available at your nearest package manager."
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

# downloadGh - Specify a URL when calling like "downloadGh https://test.com/file.txt"
downloadGh () {
    nonInteractiveCurlCheck true
    if [[ $? == "0" ]]; then
        curl -LJO --progress-bar $1
        res=$?
        if test "$res" != "0"; then
            echo -e "$error curl failed with: $res"
            exit $res
        fi
    else
        exit 1
    fi
}

# downloadAzule"
downloadAzule () {
    nonInteractiveCurlCheck true
    if [[ $? == "0" ]]; then
        curl -LJ#o azule.zip https://github.com/Al4ise/Azule/archive/refs/heads/main.zip
        res=$?
        if test "$res" != "0"; then
            echo -e "$error curl failed with: $res"
            exit $res
        fi
    else
        exit 1
    fi
}

installAzule () {
    echo -e "$info Downloading Azule..."
    rm -rf temp 2> /dev/null;mkdir temp;cd temp
    downloadAzule
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
    if [[ ! -d /usr/local/bin ]]; then
        sudo mkdir /usr/local/bin
    fi #check if /usr/local/bin exists and if not, make the folder
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

# Checks that the IPA is valid, returns 0 if OK and 1 if invalid.
# Call: validateIpa PathToIpa DoIPromptForNewIpa[true/false]
validateIpa () {
    if [[ "$1" != *".ipa" ]]; then
        if [[ $2 == "true" ]]; then
            echo -e "$error The specified file doesn't appear to be a valid IPA file"
            read -p "$(echo -e "$question Specify the path of a valid IPA file: ")" ipafile
            validateIpa $ipafile true
            if [[ $? == "0" ]]; then
                return 0
            else
                return 1
            fi
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
            echo -e "$error The specified file doesn't appear to be a valid dylib"
            read -p "$(echo -e "$question Specify the path of a valid dylib: ")" dylib
            validateDylib $dylib true
            if [[ $? == "0" ]]; then
                return 0
            else
                return 1
            fi
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
    echo -e "##################################################################################################"
    echo -e "##################################################################################################"
    echo -e "####                                                                                          ####"
    echo -e "####   This is a testing file. Commands will be added and removed at random from this file.   ####"
    echo -e "####   Use argument syntax from Variscite.                                                    ####"
    echo -e "####                                                                                          ####"
    echo -e "##################################################################################################"
    echo -e "##################################################################################################"
}
### End of functions

### Start code
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
        echo -e "$error Couldn't find Azule, it has likely already been uninstalled!"
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

# Start Test
echo -e "$init Beginning validation functions test"
echo -e "$info Got IPA file: $ipafile"
echo -e "$info Got dylib: $dylib"
echo -e "$info Got output path: $outpath"
echo "------------------------------------"
echo -e "$info validateIpa:"

validateIpa $ipafile true
if [[ $? == "0" ]]; then
    echo -e "$info IPA is valid! (Interactive)"
else
    echo -e "$error IPA is invalid! (Interactive)"
fi

validateIpa $ipafile
if [[ $? == "0" ]]; then
    echo -e "$info IPA is valid!"
else
    echo -e "$error IPA is invalid!"
fi

echo "------------------------------------"
echo -e "$info validateDylib:"

validateDylib $dylib true
if [[ $? == "0" ]]; then
    echo -e "$info dylib is valid! (Interactive)"
else
    echo -e "$error dylib is invalid! (Interactive)"
fi 

validateDylib $dylib
if [[ $? == "0" ]]; then
    echo -e "$info dylib is valid!"
else
    echo -e "$error dylib is invalid!"
fi

echo "------------------------------------"
echo -e "$info validatePath:"

validatePath $outpath
if [[ $? == "0" ]]; then
    echo -e "$info Path is valid!"
else
    echo -e "$error Path is invalid!"
fi