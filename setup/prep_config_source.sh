#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../.. && pwd )"

mkdir -p $CONFIG_DIR/poc-config-source
cp $SCRIPT_DIR/config-source.yml $CONFIG_DIR/poc-config-source/config-source-populated.yml

echo "Populate configuration by changing CHANGEME values in $CONFIG_DIR/poc-config-source/config-source-populated.yml"
echo "Then run $SCRIPT_DIR/generate-config.sh"
