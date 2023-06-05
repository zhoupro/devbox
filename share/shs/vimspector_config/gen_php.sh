#!/bin/bash

FILE_NAME=".vimspector.json"
cat << 'EOF' > $FILE_NAME
{
"configurations": {
    "web": {
      "adapter": "vscode-php-debug",
      "configuration": {
        "name": "Listen for XDebug",
        "type": "php",
        "request": "launch",
        "port": 9000,
        "stopOnEntry": false,
        "pathMappings": {
          "/var/www/html": "${workspaceRoot}"
        }
      }
    },

    "script": {
      "adapter": "vscode-php-debug",
      "configuration": {
        "name": "Launch currently open script",
        "type": "php",
        "request": "launch",
        "program": "${file}",
        "cwd": "${fileDirname}",
        "port": 9000
      }
    }
  }
}
EOF
sed -i "s#FuncName#$1#g" $FILE_NAME
