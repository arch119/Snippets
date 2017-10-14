#!/bin/sh

process-args(){
    if [ $# -gt 3 ]; then 
        echo "Usage: process-args [flags] [subdir] [branch]"
        return 1
    fi
    local flags=""
    if [ ! -z "$1" -a "${1:0:1}" == "-" ]; then
        flags="$1"
        shift
    fi

    local subdir=${1:-.}
    local branch=${2:-master}

    echo "Checking out branch[$branch] to subdir[$subdir] using flags[$flags]"
}

process-args 
process-args "-a -b -c" 
process-args -a -b -c subdir master
echo $?
process-args subdir 
process-args subdir develop
process-args "-a -b -c" subdir develop