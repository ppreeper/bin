#!/bin/bash
# Color variables
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgre=${txtbld}$(tput setaf 2) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}


echoblue () {
    echo "${bldblu}$1${txtrst}"
}
echored () {
    echo "${bldred}$1${txtrst}"
}
echogreen () {
    echo "${bldgre}$1${txtrst}"
}

echoblue hello
echored hello
echogreen hello
echo hello
