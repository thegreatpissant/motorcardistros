#!/bin/env bash

MOTORCARKS=fedora-motorcar-live-desktop.ks
LABLENAME=Motorcar-DK1
DEBUGFILE=motorcar_distro_debug

if [ -f $DEBUGFILE ]; then
  rm $DEBUGFILE
fi;

livecd-creator --verbose --config=$MOTORCARKS --fslabel=$LABLENAME --cache=/var/cache/live  --logfile=$DEBUGFILE 
