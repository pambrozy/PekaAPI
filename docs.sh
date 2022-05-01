#!/bin/bash

swift package --allow-writing-to-directory ./docs \
    generate-documentation --target PekaAPI \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path PekaAPI \
    --output-path ./docs
