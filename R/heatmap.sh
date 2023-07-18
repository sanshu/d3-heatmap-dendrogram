#!/bin/bash

export PATH='/sbin':'/bin':'/usr/sbin':'/usr/bin'
export TERM=screen
export LANG=en_US.UTF-8
export SHLVL=1

Rscript heatmap.r $1
