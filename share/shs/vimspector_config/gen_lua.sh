#!/bin/bash

FILE_NAME=".vimspector.json"
cat << 'EOF' > $FILE_NAME
{
  "$schema": "https://puremourning.github.io/vimspector/schema/vimspector.schema.json#",
  "configurations": {
    "lua": {
      "adapter": "lua-local",
      "filetypes": [ "lua" ],
      "configuration": {
        "request": "launch",
        "type": "lua-local",
        "cwd": "${workspaceFolder}",
        "program": {
          "lua": "lua",
          "file": "${file}"
        }
      }
    }
  }
}
EOF
