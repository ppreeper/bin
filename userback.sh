#!/bin/bash
DCMD="$(which duplicity)"
HOST=`hostname`
# DEST="file:///var/data/backup"
DEST="rsync://rsync@vmnas52::/computer-backups/"${HOST}
EXCLUDE=${HOME}/exclude-list
MODE=${1}
USER=${2}
FILE=${3}
TIME=""
if [ "${4}" != "" ]; then
    TIME=${4}
fi

function backfull(){
    ${DCMD} full --no-encryption --exclude-filelist ${EXCLUDE} /home/${1} ${DEST}/${1}
}

function backincr(){
    ${DCMD} incr --no-encryption --exclude-filelist ${EXCLUDE} /home/${1} ${DEST}/${1}
}

function backclear(){
    ${DCMD} remove-all-but-n-full 2 --force ${DEST}/${1}
}

function backcleanup(){
    ${DCMD} cleanup --no-encryption --force ${DEST}/${1}
}

function backverify(){
    ${DCMD} verify --no-encryption ${DEST}/${1} /home/${1}
}

function backlist(){
    ${DCMD} list-current-files ${DEST}/${1}
}

function backstatus(){
    ${DCMD} collection-status ${DEST}/${1}
}

function backrestore(){
    if [ "${3}" == "" ]; then
        ${DCMD} --no-encryption --file-to-restore "${2}" ${DEST}/${1} "/home/${1}/${2}"
    else
        ${DCMD} -t ${3} --no-encryption --file-to-restore "${2}" ${DEST}/${1} "/home/${1}/${2}"
    fi
}

if [ "${MODE}" == "full" ]; then
    backfull "${USER}"
fi

if [ "${MODE}" == "incr" ]; then
    backincr "${USER}"
fi

if [ "${MODE}" == "clear" ]; then
    backclear "${USER}"
fi

if [ "${MODE}" == "cleanup" ]; then
    backcleanup "${USER}"
fi

if [ "${MODE}" == "verify" ]; then
    backverify "${USER}"
fi

if [ "${MODE}" == "list" ]; then
    backlist "${USER}"
fi

if [ "${MODE}" == "status" ]; then
    backstatus "${USER}"
fi

if [ "${MODE}" == "restore" ]; then
    backrestore "${USER}" "${FILE}" "${TIME}"
fi
