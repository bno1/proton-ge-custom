#!/bin/bash

set -ex

export PS4="\033[0;31m+ \033[0m"

function update_submodule() {
    local dir=$1
    local branch=$2

    git -C "$dir" fetch
    git -C "$dir" checkout "$branch"
    git -C "$dir" reset --hard origin/"$branch"
    git -C "$dir" submodule update --recursive --init
}

update_submodule dxvk/ master
update_submodule dxvk-nvapi/ master
update_submodule vkd3d-proton/ master
