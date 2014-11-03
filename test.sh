#!/bin/bash
for i in `find tests/ -name "test*"; basename $i`; do ./tests/$i/$i;done
