#!/bin/sh -e

################################################################################
# $ sh main.sh 1
################################################################################

readonly ARG1=$1

echo ----- ARG1 % 3 --- ${ARG1} % 3
echo $(($ARG1 % 3))
echo ------------------------------
