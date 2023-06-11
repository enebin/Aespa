#! /bin/sh

BUILD_PATH=".build"

xcodebuild docbuild \
-scheme 'Aespa' \
-destination 'generic/platform=iOS' \
-derivedDataPath ${BUILD_PATH}/ \
|| exit 1

DOCCARCHIVE_PATH=$(find ${BUILD_PATH} -type d -name '*.doccarchive')
OUTPUT_PATH="$1"
GITHUB_REMOTE_NAME="Aespa"

echo "1️⃣ 1️⃣ 1️⃣ Now processing ${DOCCARCHIVE_PATH}"

$(xcrun --find docc) process-archive \
transform-for-static-hosting ${DOCCARCHIVE_PATH} \
--output-path ${OUTPUT_PATH} \
--hosting-base-path "${GITHUB_REMOTE_NAME}" \
|| exit 1

echo "✅ ✅ ✅ Done! Page's saved in ${OUTPUT_PATH}"