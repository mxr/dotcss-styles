#!/bin/sh

safe_sed() {
  if sed --version > /dev/null 2>&1; then
    sed -i"" "$@"
  else
    sed -i "" "$@"
  fi
}
