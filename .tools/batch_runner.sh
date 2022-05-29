#!/bin/bash
cd "$(realpath "$(dirname "$0")")" || exit 1

errors_count=0
startswith=$1
action=$2
extension=$3
if [[ -z $extension ]]; then
  extension=".sh"
fi

for d in ../*/; do
  dir_name=${d:3}
  matched_dirname=${startswith}${dir_name/$startswith/}
  if [[ "$matched_dirname" == "$dir_name" ]]; then
    create_install_name="${d}create_install$extension"
    if [[ -f "$create_install_name" ]]; then
      echo ">> Test $create_install_name"
      if [[ "$action" == "create" ]]; then
        "$create_install_name"
        errorlevel=$?
        if [[ $errorlevel -ne 0 ]]; then
          errors_count=$((errors_count+1))
          echo "<< Failed."
        else
          echo "<< Passed."
        fi
      fi
    fi
  fi
done

echo Errors: "$errors_count"
exit "$errors_count"
