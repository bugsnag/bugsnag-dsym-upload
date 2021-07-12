#!/usr/bin/env bash

bin/bugsnag-dsym-upload \
    --upload-server "http://localhost:$MOCK_API_PORT" \
    ${UPLOAD_ARGS[@]} \
    "$DSYMS_PATH"
