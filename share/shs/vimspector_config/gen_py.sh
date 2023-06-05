#!/bin/bash

FILE_NAME=".vimspector.json"
cat << 'EOF' > $FILE_NAME
{
    "$schema": "https://puremourning.github.io/vimspector/schema/vimspector.schema.json#",
    "adapters": {
      "nlua": {
        "host": "127.0.0.1",
        "port": "8086"
      }
    },
  
    "configurations": {
      "osv": {
        "adapter": "nlua",
        "configuration": {
          "request": "attach"
        }
      },
      
      "Py: Run current script": {
        "adapter": "debugpy",
        "configuration": {
          "request": "launch",
          "program": "${file}",
          "args": [ "*${args:--update-gadget-config}" ],
          "justMyCode#json": "${justMyCode:false}"
        }
     }
    }
  }
EOF
sed -i "s#FuncName#$1#g" $FILE_NAME
