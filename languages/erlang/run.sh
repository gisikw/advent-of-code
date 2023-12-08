#!/bin/bash

erlc solution.erl
erl -noshell -run solution main $1 $2 -s init stop
