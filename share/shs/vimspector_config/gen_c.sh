#!/bin/bash

FILE_NAME=".vimspector.json"
cat << 'EOF' > $FILE_NAME
{
  "configurations": {
    "redis debug": {
         "adapter": "vscode-cpptools",
         "configuration": {
            "request": "launch",
            "program": "${EXEC_FILE}",
            "args": [ "*${args: /opt/github/redis/redis.conf}" ],
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
