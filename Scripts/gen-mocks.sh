#!/bin/bash

ROOT_PATH="../"
ROOT_DIR_NAME=$(basename "$(cd "$ROOT_PATH" && pwd)")
if [ "$ROOT_DIR_NAME" != "Aespa" ]; then
    echo "❌ Error: Script's not called in proper path."
    exit 1
fi

if [ ! -f run ]; then
    curl -Lo run https://raw.githubusercontent.com/Brightify/Cuckoo/master/run && chmod +x run
fi

PROJECT_NAME="Aespa"
TESTER_NAME="TestHostApp"
PACKAGE_SOURCE_PATH="${ROOT_PATH}/Sources/Aespa"
OUTPUT_FILE="${ROOT_PATH}/Tests/Tests/Mock/GeneratedMocks.swift"
SWIFT_FILES=$(find "$PACKAGE_SOURCE_PATH" -type f -name "*.swift" -print0 | xargs -0)

echo "✅ Generated Mocks File = ${OUTPUT_FILE}"
echo "✅ Mocks Input Directory = ${PACKAGE_SOURCE_PATH}"

./run --download generate --testable "${PROJECT_NAME}" --output "${OUTPUT_FILE}" ${SWIFT_FILES}

# Check the exit status of the last command
if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to generate mocks."
    exit 1
fi

echo "✅ Generating mock was successful"