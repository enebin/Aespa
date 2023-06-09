#! /bin/sh

xcodebuild docbuil-nascheme Aespa \
-destination 'generic/platform=iOS' \
-derivedDataPath .build/

DOCCARCHIVE_PATH=$(find ./.build -type d -name '*.doccarchive')
OUTPUT_PATH="$1"
GITHUB_REMOTE_NAME="Aespa"

echo "1️⃣ 1️⃣ 1️⃣ Now processing ${DOCCARCHIVE_PATH}"

$(xcrun --find docc) process-archive \
transform-for-static-hosting ${DOCCARCHIVE_PATH} \
--output-path ${OUTPUT_PATH} \
--hosting-base-path ${GITHUB_REMOTE_NAME}

echo "✅ ✅ ✅ Done! Page's saved in ${OUTPUT_PATH}"
