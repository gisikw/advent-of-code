#!/bin/sh
sbt "runMain aoc.Solution $1 $2" | sed '/^[[:space:]]*$/d'
