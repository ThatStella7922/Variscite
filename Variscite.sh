#!/bin/bash

# Variscite - by ThatStella7922 - https://thatstel.la
# Shoutout to crystall1nedev my beloved (find her site at https://crystall1ne.dev!)
ver="2023.0701.0"

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
## Checks for Azule and doesn't prompt for installation. Returns 1 if Azule not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveAzuleCheck () {
    if [[ ! -f "$(which azule)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
            echo -e "$error Cannot continue without Azule."
            echo -e "$info Variscite can install Azule for you - Run Variscite with -h to learn more."
            echo -e "$info Alternatively, you can manually install it at https://github.com/Al4ise/Azule/wiki."
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

## Checks for the Xcode command line tools and doesn't prompt for installation. Returns 1 if Xcode not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveXcodeCltCheck () {
    if ! xcode-select -p 1>/dev/null; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate the Xcode Command Line Tools."
            echo -e "$info You can install them manually by running xcode-select --install"
            return 1
        else
            return 1
        fi
    else
        # good to go
        return 0
    fi
}

# Checks if we are running on Darwin (macOS/iOS). Returns 0 if we are, else returns 1.
checkAreWeOnDarwin () {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        return 0
    else
        return 1
    fi
}

# Checks if we are running on some type of Linux. Returns 0 if we are, else returns 1.
checkAreWeOnLinux () {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        return 0
    else
        return 1
    fi
}

## Checks if we are running on jailbroken iOS. Returns 0 if we are, else returns 1.
# Checks using the presence of apt, so this might trigger on Procursus-strapped macOS. not my problem tho :trolley:
checkAreWeOnJbIos () {
    checkAreWeOnDarwin
    if test "$?" == "0"; then
        # we are on darwin, actually check if we are on ios now
        if [[ "$(sw_vers -productName)" == "iOS" ]]; then
            return 0
        else
            # we are not on ios so stop here
            return 1
        fi
    else
        # we are not even on darwin so stop here
        return 1
    fi
}

# Checks if we are running on macOS. Returns 0 if we are, else returns 1.
checkAreWeOnMac () {
    checkAreWeOnDarwin
    if test "$?" == "0"; then
        # we are on darwin, actually check if we are on macOS now
        if [[ "$(sw_vers -productName)" == "macOS" ]] || [[ "$(sw_vers -productName)" == "Mac OS X" ]]; then
            return 0
        else
            # we are not on ios so stop here
            return 1
        fi
    else
        # we are not even on darwin so stop here
        return 1
    fi
}

# Checks for curl and doesn't prompt for installation. Returns 1 if curl not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveCurlCheck () {
    if [[ ! -f "$(which curl)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate curl. If it's already installed, make sure that it's in the PATH."
            echo -e "$info curl should be available at your nearest package manager."
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

nonInteractiveGitCheck () {
    if [[ ! -f "$(which git)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate git. If it's already installed, make sure that it's in the PATH."
            echo -e "$info git should be available at your nearest package manager."
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

# Downloads a file using curl - Specify a URL when calling like "curlGetFile https://test.com/file.txt"
curlGetFile () {
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

# downloadAzule - Downloads Azule from the GitHub repo with git clone or curl if git fails
downloadAzule () {
    nonInteractiveCurlCheck
    if [[ $? == "0" ]]; then

        # curl is available
        git clone https://github.com/Al4ise/Azule.git AzuleTemp
        res=$?
        if test "$res" != "0"; then
            echo -e "$error git failed with: $res"
            echo -e "$info Retrying download again using curl!"
            curl -LJ#o Azule.zip https://github.com/Al4ise/Azule/archive/refs/heads/main.zip
            res=$?
            if test "$res" != "0"; then
                echo -e "$error curl failed with: $res"
                exit $res
            else
                # curl works, unzip so installer can install
                unzip -q Azule.zip
                mv Azule-main AzuleTemp
                return 0
            fi
        fi
    else
        # curl is not available
        git clone https://github.com/Al4ise/Azule.git AzuleTemp
        res=$?
        if test "$res" != "0"; then
            echo -e "$error git failed with: $res"
            echo -e "$info Cannot retry with curl as it's not installed or in the PATH."
            exit $res
        fi
        return 0
    fi
}

installAzule () {
    echo -e "$info Downloading Azule..."
    rm -rf temp 2> /dev/null;mkdir temp;cd temp
    downloadAzule
    echo -e "$info Installing Azule (this may require your password)..."
    if [[ ! -d ~/Applications ]]; then
        mkdir ~/Applications
    fi #check if applications folder exists at ~ so we can put Azule there
    if [[ -d ~/Applications/Azule-main ]]; then
        rm -rf ~/Applications/Azule-main
    fi #check if azule is there with the old path and if so delete it
    if [[ -d ~/Applications/Azule ]]; then
        rm -rf ~/Applications/Azule
    fi #check if azule is there and if so delete it
    mv AzuleTemp/ ~/Applications/Azule
    cd ..
    rm -rf temp
    if [[ ! -d /usr/local/bin ]]; then
        sudo mkdir /usr/local/bin
    fi #check if /usr/local/bin exists and if not, make the folder
    sudo ln -sf ~/Applications/Azule/azule /usr/local/bin/azule
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
    fi #check if azule is there with the old path and if so delete it
    if [[ -d ~/Applications/Azule ]]; then
        rm -rf ~/Applications/Azule
    fi #check if azule is there and if so delete it
    if [[ $? == "0" ]]; then
        echo -e "$info Deleted the Azule folder, will now remove symlink..."
    else
        echo -e "$error Failed to remove the Azule folder with error code $?, see ~/Applications/ to remove it yourself then attempt uninstallation again."
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


### Start code
## Make Variscite stop execution on jailbroken iOS
## Why? I don't know how to handle rootless, as this was only tested on rootfull and fakefs.
## don't want to brick people's shit and have them yell at me even though I say it's unsupported
if ! [ checkAreWeOnJbIos ]; then
    echo -e "$error Variscite doesn't support jailbroken iOS devices right now."
    echo -e "$error See the README for more information."
    exit 1
fi

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
        echo -e "$info You can find the files at ~/Applications/Azule."
        echo -e "$info You can also find the executable symlink at /usr/local/bin/azule"
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

# Check for non-interactive arguments
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

### Non-interactive mode execution
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
                    echo -e "$success Azule finished patching the IPA file."
                    exit 0
                else
                    echo -e "$error There was a problem while patching the IPA file. Please see above."
                    exit 1
                fi
            fi
        else
            # Error message from no Azule was triggered in the above call to nonInteractiveAzuleCheck
            exit 1
        fi
    fi
fi


### Interactive mode execution
# Check what we are running on
if [ checkAreWeOnMac ]; then
    # we are on macOS, check for xcode clt
    nonInteractiveXcodeCltCheck
    if [[ $? == "1" ]]; then
        echo -e "$error Xcode Command Line Tools are not installed."
        echo -e "$question Variscite can request the installation of them for you."
        read -p "$(echo -e "$question Continue? y/n: ")" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]];then
            xcode-select --install
            echo -e "$info Variscite has requested the installation of Xcode Command Line Tools for you."
            echo -e "$info Once they are installed, just re-run Variscite!"
            exit 0
        else
            echo -e "$error Cannot continue without Xcode Command Line Tools."
            echo -e "$info You can install them manually by running xcode-select --install"
            exit 1
        fi
    else 
        echo
    fi
    
    # check for curl
    nonInteractiveCurlCheck
    if [[ $? == "1" ]]; then
        echo -e "$warn Variscite couldn't locate curl. If it's already installed, make sure that it's in the PATH."
        echo -e "$info curl isn't required, but it is used as a fallback for downloads and it might do more in the future."
        echo -e "$info curl should be available at your nearest package manager."
        echo
    fi

    # i think that's it idk i'm kinda sleepy if i'm going to be honest

elif [ checkAreWeOnJbIos ]; then
    nonInteractiveCurlCheck
    if [[ $? == "1" ]]; then
        echo -e "$warn Variscite couldn't locate curl. If it's already installed, make sure that it's in the PATH."
        echo -e "$info curl isn't required, but it is used as a fallback for downloads and it might do more in the future."
        echo -e "$info curl should be available at your nearest package manager."
        echo
    fi

    nonInteractiveGitCheck
    if [[ $? == "1" ]]; then
        echo -e "$error Variscite couldn't locate git. If it's already installed, make sure that it's in the PATH."
        echo -e "$error Cannot continue without Azule."
        echo -e "$info git should be available at your nearest package manager."
        exit 1
    fi
    # was goign to do more stuff here but ios is not supported
    
elif [ checkAreWeOnLinux ]; then
    nonInteractiveCurlCheck
    if [[ $? == "1" ]]; then
        echo -e "$warn Variscite couldn't locate curl. If it's already installed, make sure that it's in the PATH."
        echo -e "$info curl isn't required, but it is used as a fallback for downloads and it might do more in the future."
        echo -e "$info curl should be available at your nearest package manager."
        echo 
    fi

    nonInteractiveGitCheck
    if [[ $? == "1" ]]; then
        echo -e "$error Variscite couldn't locate git. If it's already installed, make sure that it's in the PATH."
        echo -e "$error Cannot continue without Azule."
        echo -e "$info git should be available at your nearest package manager."
        exit 1
    fi

    # i think this is it for linux as well

else
    echo -e "$warn Variscite couldn't determine what OS you are running on."
    echo -e "$warn Variscite will continue running but it might not work as expected."
    echo
fi


# Check for azule
if [ ! -f "$(which azule)" ]; then
    echo -e "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
    echo -e "$question Variscite can download and install Azule for you."
    read -p "$(echo -e "$question Install Azule? y/n: ")" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]];then
        installAzule
        echo
    else
        echo -e "$error Cannot continue without Azule."
        echo -e "$info You can manually install it from https://github.com/Al4ise/Azule/wiki"
        exit 1
    fi
fi

echo -e "$init Welcome to Variscite's interactive mode!"
echo -e "$init We will need to collect some info about the files you want to work with."

# Check if an IPA file was already passed
if [[ -z $ipafile ]]; then
    # If not then prompt for one and validate
    read -p "$(echo -e "$question Please specify the path of the IPA file you want to patch: ")" ipafile
    validateIpa $ipafile true;iparesult=$?
    if [[ $iparesult == "1" ]]; then
        exit 1
    fi
else
    # If found in variable then validate
    validateIpa $ipafile true;iparesult=$?
    if [[ $iparesult == "1" ]]; then
        exit 1
    else
        echo -e "$success Found an IPA file at $ipafile, will patch this one!"
        echo
    fi
fi

# Check if a dylib file was already passed
if [[ -z $dylib ]]; then
    # If not then prompt for one and validate
    read -p "$(echo -e "$question Please specify the path of the dylib file you want to patch with: ")" dylib
    validateDylib $dylib;dylibresult=$?
    if [[ $dylibresult == "1" ]]; then
        exit 1
    fi
else
    # If found in variable then validate
    validateDylib $dylib;dylibresult=$?
    if [[ $dylibresult == "1" ]]; then
        exit 1
    else
        echo -e "$success Found a dylib file at $dylib, will patch this one!"
    fi
fi

# Check if an output path was already passed
if [[ -z $outpath ]]; then
    # If not then prompt for one and validate
    echo 
    echo -e "$init Please specify the folder for saving the patched IPA (do not specify a filename like ~/Desktop/patched.ipa)"
    read -p "$(echo -e "$question Path: ")" outpath
    validatePath $outpath;pathresult=$?
    if [[ $pathresult == "1" ]]; then
        exit 1
    fi
else
    # If found in variable then validate
    validatePath $outpath;pathresult=$?
    if [[ $pathresult == "1" ]]; then
        exit 1
    else
        echo -e "$success Found an output path at $outpath, will output here.!"
    fi
fi

# done collecting info, check everything *again* just to make sure, then patch same as noninteractive mode
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
            echo -e "$success Azule finished patching the IPA file."
            exit 0
        else
            echo -e "$error There was a problem while patching the IPA file. Please see above."
            exit 1
        fi
    fi
else
    # Error message from no Azule was triggered in the above call to nonInteractiveAzuleCheck
    exit 1
fi

echo "If you are seeing this then I left some codepath open. Please create an issue or yell at me (you can find contact info on https://thatstel.la)"