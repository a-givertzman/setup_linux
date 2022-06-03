#!/bin/bash

git clone https://github.com/kreijack/xlibinput_calibrator.git

cd xlibinput_calibrator/src/

xlibinput_calibrator/src$ make g++ -MT main.o -MMD -MP -MF .d/main.Td -Wall -pedantic -std=c++17   -c -o main.o main.cc
