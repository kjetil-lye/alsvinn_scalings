#!/bin/bash
head -n 144 $1 > tmp;
cat tmp > $1;
