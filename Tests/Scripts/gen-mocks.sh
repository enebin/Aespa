#!/bin/bash

if [ ! -f run ]; then
    curl -Lo run https://raw.githubusercontent.com/Brightify/Cuckoo/master/run && chmod +x run
    ./run --download
fi

PROJECT_NAME="Aespa"
TESTER_NAME="Aespa-iOS-test"
PACKAGE_SOURCE_PATH="../../Sources/Aespa"
OUTPUT_FILE="../${TESTER_NAME}Tests/Mock/GeneratedMocks.swift"
SWIFT_FILES=$(find "$PACKAGE_SOURCE_PATH" -type f -name "*.swift" -print0 | xargs -0)

echo "✅ Generated Mocks File = ${OUTPUT_FILE}"
echo "✅ Mocks Input Directory = ${PACKAGE_SOURCE_PATH}"

./run generate --testable "${PROJECT_NAME}" --output "${OUTPUT_FILE}" ${SWIFT_FILES}
