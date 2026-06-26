#!/bin/bash

set -ex

git reset --recurse-submodules
git checkout --recurse-submodules .
git submodule foreach --recursive git clean -df
