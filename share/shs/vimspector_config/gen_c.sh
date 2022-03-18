#!/bin/bash

FILE_NAME=".vimspector.json"
cat << 'EOF' > $FILE_NAME
{
  "configurations": {
    "linux debug": {
         "adapter": "vscode-cpptools",
         "configuration": {
            "request": "launch",
            "program": "${EXEC_FILE}",
            "MIMode": "gdb",
            "stopAtEntry": true,
            "setupCommands": [
                {"text": "-gdb-set follow-fork-mode ${FORK_MODE:child}"}
            ]
          }
      }
    }
}
EOF
sed -i "s#FuncName#$1#g" $FILE_NAME
