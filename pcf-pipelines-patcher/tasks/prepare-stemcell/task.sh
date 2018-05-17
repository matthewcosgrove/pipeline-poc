#!/bin/bash
set -eu

echo
echo "Preparing stemcell..."
file_path=`find ./pivnet-product -name *.tgz`
mv $file_path prepared-stemcell
ls prepared-stemcell
