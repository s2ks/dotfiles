#!/bin/bash

PROC=polybar
LOG=/tmp/polybar.log

killall --quiet $PROC

while pgrep -x $PROC > /dev/null; do sleep 1; done

echo -e "------------\n$(date):" | tee -a $LOG
polybar stbar >> $LOG 2>&1 & disown

# done
