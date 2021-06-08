#!/bin/bash

set -e
echo "setting up ps1"
cp -v ./.ps1 ~
echo "source ~/.ps1" >> ~/.bashrc
echo "done, run source ~/.bashrc or relog"
