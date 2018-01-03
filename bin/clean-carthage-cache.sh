#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# Yes...twice...for some reason the first time complains about directorie not being empty
# despite -f (force) flag.
rm -rf $ROOT_DIR/Carthage
rm -rf $ROOT_DIR/Carthage
