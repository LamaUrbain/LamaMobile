#!/bin/bash
for i in `for i in `find toto/ -name "test*"`; basename $i`; do ./tests/$i/$i;done
