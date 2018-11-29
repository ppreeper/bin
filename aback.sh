#!/bin/bash
# Global Variables
export RSYNC_PASSWORD=Gasket2008
WS=`hostname`
EXC=".sync .directory .@__thumb .cache .thumbnails @Recycle .Trash-1000 $HOME/.cache"
extensions="lzo diff tar.gz tar.lzo"

# Backup portable
localdisk="bigbackup"
mounted=/media/$USER/$localdisk/.mounted

# QNAP Settings
username="admin"
# Backup DC
dcsvr="vmnas52"
dcfldrs="lxcbackup server-backups/doc server-backups/db vmiso"
# Backup Offsite
ossvr="preeper-nas"
remotedisk="/share/bkp/$WS"

#folders="/etc /home/peterp /var/data"

function smnt(){
    mkdir -p "/mnt/${1}/${2}/"
    sshfs -C -o reconnect "${1}:${2}" "/mnt/${1}/${2}/"
}

function sumnt(){
    fusermount -u "/mnt/${1}/${2}/"
    rmdir -p "/mnt/${1}/${2}/" 2> /dev/null
}

function exc(){
    ex=""
    for e in ${EXC}
    do
        ex="${ex} --exclude=\"${e}\""
    done
    echo ${ex}
}

function filesync(){
    rsync -rtv --inplace --progress --delete $(exc) "${1}" "${2}"
}

function cleaner(){
    echo ""
}

if [ $WS == "um35" ]; then
    echo "AT WORK"
    for fl in ${dcfldrs}
    do
        filesync rsync://rsync@$dcsvr:/${fl}/ /media/$USER/$localdisk/${fl}/
    done
fi
if [ $WS == "um0" ]; then
    echo "AT HOME"
    for fl in ${dcfldrs}
    do
        filesync /media/$USER/$localdisk/${fl}/ rsync://rsync@$ossvr:/${fl}/
    done
fi
