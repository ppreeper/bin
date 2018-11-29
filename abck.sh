#!/bin/bash
# Global Variables
export RSYNC_PASSWORD=Gasket2008
WS=`hostname`
EXC=".sync .directory .@__thumb .cache .thumbnails @Recycle .Trash-1000 $HOME/.cache"

# QNAP Settings
username="admin"
# Backup DC
dcsvr="vmnas52"
dcfldrs="lxcbackup server-backups/db server-backups/doc vmiso"
# Backup Offsite
ossvr="preeper-nas.preeper.org"

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
    rsync -rtzv --inplace --progress --delete $(exc) "${1}" "${2}"
}

for fl in ${dcfldrs}
do
    smnt $dcsvr "/share/${fl}/"
done
for fl in ${dcfldrs}
do
    filesync /mnt/$dcsvr/share/${fl}/ rsync://rsync@$ossvr:/${fl}/
done
for fl in ${dcfldrs}
do
    sumnt $dcsvr "/share/${fl}/"
done
