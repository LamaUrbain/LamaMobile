#!/bin/bash
for i in `find toto/ -maxdepth 1 -type d -name "test_*" -printf '%f\n'`; do ./tests/$i/$i;done
