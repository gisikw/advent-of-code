#!/bin/bash
# There seems to be some issue with parsing CLI args, hence this workaround
FILENAME=$1 PART=$2 roc dev solution.roc
