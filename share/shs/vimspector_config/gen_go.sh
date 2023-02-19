#!/bin/bash

FILE_NAME=".vimspector.json"
if [[ $1 =~ ^Test ]] ;then
  cat << 'EOF' > $FILE_NAME
{
  "configurations": {
      "test": {
      "adapter": {
        "extends":"delve",
        "sync_timeout":1500000,
        "iasync_timeout":1500000
      },
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
        "timeout": 3000000,
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
     "adapter": {
        "extends":"delve",
        "sync_timeout":1500000,
        "iasync_timeout":1500000
      },
      "timeout": 3000000,
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
