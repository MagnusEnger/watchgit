#!/bin/bash

cd repo

git remote -v | sed -n "s/\(.*\) (fetch)/\1/p"
