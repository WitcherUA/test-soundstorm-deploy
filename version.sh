#!/bin/bash
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0")
IFS='.' read -r MAJOR MINOR <<< "${VERSION#v}"
MINOR=$((MINOR+1))
NEW_VERSION="v$MAJOR.$MINOR"
echo "$NEW_VERSION" > VERSION
git tag "$NEW_VERSION"
git push origin "$NEW_VERSION"
echo "$NEW_VERSION"
