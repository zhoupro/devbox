#!/bin/bash

FILE_NAME=".vimspector.json"
cat << 'EOF' > $FILE_NAME
{
  "configurations": {
      "test": {
      "adapter": "vscode-go",
      "configuration": {
        "buildFlags": "-tags=BUILDTAG",
        "args": [
            "-test.v",
            "-test.run",
            "FuncName"
        ],
        "dlvLoadConfig": {
            "followPointers": true,
            "maxVariableRecurse": 2,
            "maxStringLen": 1000,
            "maxArrayValues": 64,
            "maxStructFields": -1
        },
        "request": "launch",
        "timeout": 3,
        "program": "${fileDirname}",
        "mode": "test",
        "dlvToolPath": "$HOME/go/bin/dlv"     }
    }
  }
}
EOF
sed -i "s#FuncName#$1#g" $FILE_NAME
