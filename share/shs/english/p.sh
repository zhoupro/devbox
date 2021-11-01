#!/bin/bash
if [ ! -f "/tmp/z_$1__gb_1.wav" ];then
    unzip '/vagrant_data/dict/En-En_OALD8/En-En_Oxford Advanced Learners Dictionary.dsl.dz.files.zip'  "z_$1__gb_1.wav" -d "/tmp/"
fi
ffplay -nodisp -autoexit "/tmp/z_$1__gb_1.wav"
