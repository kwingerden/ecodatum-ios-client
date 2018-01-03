#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
pushd $ROOT_DIR

carthage update --no-use-binaries --platform ios --configuration Debug

popd