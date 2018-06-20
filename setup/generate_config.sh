#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../.. && pwd )"

mkdir -p $CONFIG_DIR/poc-config/conf
cp -r $SCRIPT_DIR/* $CONFIG_DIR/poc-config

this_here_script_that_got_cloned=$CONFIG_DIR/poc-config/generate_config.sh
rm $this_here_script_that_got_cloned
this_here_other_script_that_got_cloned=$CONFIG_DIR/poc-config/prep_config_source.sh
rm $this_here_other_script_that_got_cloned
template_that_got_cloned=$CONFIG_DIR/poc-config/config-source.yml
rm $template_that_got_cloned

echo "Will generate the configuration for $CONFIG_DIR with $CONFIG_DIR/poc-config-source/config-source-populated.yml"

#NOTE: lines in source file must be terminated with a newline char
while read -r line; do
    if [[ $line =~ (^.*):+\ (.*)\ (#)(.*) ]]; then
        echo "Processing $line... Key:${BASH_REMATCH[1]},Value:${BASH_REMATCH[2]}"
        find $CONFIG_DIR/poc-config/conf -type f | xargs grep ${BASH_REMATCH[1]} -l | xargs sed -i "s|{${BASH_REMATCH[1]}}|${BASH_REMATCH[2]}|g"
    else
        if [[ ${line:0:1} != '#' ]] && [ ! -z "$line" ]; then
            echo "$line - ignored.  Invalid entry."
        else
            :
            #echo "Ignored: $line"
        fi
    fi
done < $CONFIG_DIR/poc-config-source/config-source-populated.yml

# Remove the comments at the end of the variables - useful when comparing to config not generated from the template.
find $CONFIG_DIR/poc-config/conf -type f | xargs sed -i "s/ #.*//"

echo "Success!"
echo "Successfully generated the configuration in $CONFIG_DIR"
