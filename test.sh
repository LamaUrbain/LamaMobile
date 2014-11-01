#!/bin/bash
for i in `ls tests/`; do ./tests/$i/$i;done
