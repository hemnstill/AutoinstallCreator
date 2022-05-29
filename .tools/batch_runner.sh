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
    if [[ -f "${d}create_install$extension" ]]; then
      echo ">> Test $matched_dirname"
      if [[ "$action" == "create" ]]; then
        ("${d}create_install$extension" "$external_args" && echo "<< Passed.") || {
          ((errors_count++))
          echo "<< Failed."
        }
      fi
    fi
  fi
done

echo Errors: "$errors_count"
exit "$errors_count"
