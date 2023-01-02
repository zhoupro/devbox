#!/bin/bash

FILE_NAME=".vimspector.json"
if [[ $1 =~ ^Test ]] ;then
  cat << 'EOF' > $FILE_NAME
{
  "configurations": {
      "test": {
      "adapter": "delve",
      "configuration": {
        "buildFlags": "-tags=BUILDTAG",
        "args": [
            "-test.v",
            "-test.run",
            "FuncName"
        ],
        "dlvLoadConfig": {
            "followPointers": true,
            "maxVariableRecurse": 8,
            "maxStringLen": 1000,
            "maxArrayValues": 64,
            "maxStructFields": -1
        },
        "request": "launch",
        "timeout": 30,
        "program": "${fileDirname}",
        "mode": "test",
        "dlvToolPath": "$HOME/go/bin/dlv"     }
    }
  }
}
EOF

else

  cat << 'EOF' > $FILE_NAME
{
  "configurations": {
    "run": {
      "adapter": "delve",
      "filetypes": [ "go" ],
      "variables": {
         "dlvFlags": "--check-go-version=false"
      },
      "configuration": {
        "request": "launch",
        "program": "${fileDirname}",
        "mode": "debug"
      }
    }
  }
}
EOF

fi

sed -i "s#FuncName#$1#g" $FILE_NAME
