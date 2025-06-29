#!/bin/bash
input_file=$1
part=$2
cobc -x -free solution.cob -o solution && (echo $input_file; echo $part) | ./solution
