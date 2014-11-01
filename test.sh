#!/bin/bash
for i in $(ls -d */); do ./tests/$i$i;done
