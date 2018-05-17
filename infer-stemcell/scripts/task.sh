#!/bin/bash

set -eu

STEMCELL_VERSION=$(
  cat ./pivnet-product/metadata.json |
  jq --raw-output \
    '
    [
      .Dependencies[]
      | select(.Release.Product.Name | contains("Stemcells"))
      | .Release.Version
    ]
    | map(split(".") | map(tonumber))
    | transpose | transpose
    | max // empty
    | map(tostring)
    | join(".")
    '
)

if [ -z "$STEMCELL_VERSION" ]; then
  echo "Cannot bundle stemcell with product"
  echo "Metadata not available containing required stemcell version within product! Check the released binary and if this is indeed the case then raise a support ticket"
  exit 1
fi

echo "Downloading stemcell $STEMCELL_VERSION"

product_slug=$(
  jq --raw-output \
    '
    if any(.Dependencies[]; select(.Release.Product.Name | contains("Stemcells for PCF (Windows)"))) then
      "stemcells-windows-server"
    else
      "stemcells"
    end
    ' < pivnet-product/metadata.json
)

echo Downloading $product_slug

IAAS=vsphere

pivnet-cli login --api-token="$PIVNET_API_TOKEN"
pivnet-cli download-product-files -p "$product_slug" -r $STEMCELL_VERSION -g "*${IAAS}*" --accept-eula

SC_FILE_PATH=`find ./ -name *.tgz`

if [ ! -f "$SC_FILE_PATH" ]; then
  echo "Stemcell file not found!"
  exit 1
fi

echo TODO: embed stemcell within zip

# taken from embedded script in original pivnet-to-s3 pipeline.yml
cd pivnet-product/ && tar -czvf ../tile/$(cat ./version | cut -f1 -d"#").tgz . && cd ..
