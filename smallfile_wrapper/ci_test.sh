#!/bin/bash

set -x

source ci/common.sh

# Build image for ci
podman build --tag=quay.io/cloud-bulldozer/smallfile:snafu_ci -f smallfile_wrapper/Dockerfile . && podman push quay.io/cloud-bulldozer/smallfile:snafu_ci

cd ripsaw

sed -i 's/smallfile:master/smallfile:snafu_ci/g' roles/smallfile-bench/templates/*

# Build new ripsaw image
update_operator_image snafu_ci

get_uuid test_smallfile.sh
uuid=`cat uuid`

cd ..

index="ripsaw-smallfile-results ripsaw-smallfile-rsptimes"

check_es $uuid $index
exit $?
