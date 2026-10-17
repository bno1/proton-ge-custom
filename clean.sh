#!/bin/bash

set -ex

git reset
git checkout -- .
git submodule foreach --recursive 'git checkout -f $sha1 && git clean -df'
