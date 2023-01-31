#!/usr/bin/env bash
set -eu

main() {
  repository_url=$(git remote get-url origin)
  repository_name="$(basename "$repository_url" .git)"

  echo "--> Updating build system of $repository_name"

  if ! grep -Eq "GTNewHorizons/ExampleMod1\\.7\\.10/(main|master)/build\\.gradle" build.gradle; then
    echo "$repository_name is not using the ExampleMod buildscript"
    exit 1
  fi

  if ! grep -Fq "com.gtnewhorizons.retrofuturagradle" build.gradle; then
    echo "$repository_name is not using the RFG buildscript"
    exit 1
  fi

  chmod +x gradlew
  git add --chmod=+x gradlew # Fix file permissions in git permanently
  ./gradlew updateBuildScript
  ./gradlew clean build test

  echo "<-- Build system updated successfully"
}

# shellcheck disable=SC2068
main $@
