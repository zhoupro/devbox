#!/bin/bash

wget https://go.microsoft.com/fwlink/?LinkID=760868 -O code.deb && \
sudo apt install -y ./code.deb && \
rm -f ./code.deb