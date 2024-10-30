#!/bin/bash

current_version=$(grep 'version:' pubspec.yaml | sed 's/version: //')

version_major=$(echo $current_version | cut -d. -f1)
version_minor=$(echo $current_version | cut -d. -f2)
version_patch=$(echo $current_version | cut -d. -f3 | cut -d+ -f1)

new_version_patch=$((version_patch + 1))

new_version="$version_major.$version_minor.$new_version_patch"

sed -i "s/version: .*/version: $new_version/" pubspec.yaml

echo "Yeni versiyon: $new_version"
