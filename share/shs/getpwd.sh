#!/bin/bash

parent_dir_name=`pwd`

while [[ $parent_dir_name != "/"  ]]; do
    if test -f "${parent_dir_name}/go.mod"; then
        echo -n "${parent_dir_name}/go.mod"
    fi
    parent_dir_name=`dirname $parent_dir_name`
done
