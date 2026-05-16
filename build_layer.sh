#!/usr/bin/env bash
set -euo pipefail

# Usage: ./build_layer.sh [python-version]
# Example: ./build_layer.sh 3.9

PYTHON_VERSION=${1:-3.9}
LAMBDA_BUILD_IMAGE="lambci/lambda:build-python${PYTHON_VERSION}"
REQ_FILE="requirements.txt"
BUILD_DIR="python"
OUTPUT_ZIP="pillow_layer_py${PYTHON_VERSION}.zip"

echo "Building Pillow layer for Python ${PYTHON_VERSION} using image ${LAMBDA_BUILD_IMAGE}"

rm -rf ${BUILD_DIR} ${OUTPUT_ZIP}
mkdir -p ${BUILD_DIR}

docker run --rm -v "$PWD":/var/task ${LAMBDA_BUILD_IMAGE} /bin/bash -lc \
  "python -m pip install --upgrade pip && pip install -r ${REQ_FILE} -t ${BUILD_DIR} --upgrade && chmod -R a+r ${BUILD_DIR}"

zip -r ${OUTPUT_ZIP} ${BUILD_DIR}

echo "Created ${OUTPUT_ZIP} — upload this to Lambda Layers for the matching Python runtime."
