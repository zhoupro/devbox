#!/bin/bash
cd /vagrant_data/shs/english
./daydict.sh 20 | xargs -n 1 ./dict-with-pro.sh > /tmp/words.txt

