#!/bin/bash
RESTIC_PASSWORD="backup"
RESTIC_REPOSITORY="sftp:backups:/share/users/peterp/um35"

# prune
restic forget --tag `hostname` --keep-within 0y2m0d --prune

# backup
restic backup --tag `hostname` --exclude-file $HOME/.cfg/bkp.exclude --files-from ${HOME}/.cfg/bkp.include
