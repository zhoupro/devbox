#!/bin/bash

FILE_NAME=".vimspector.json"
if [[ $1 =~ ^Test_ ]] ;then
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

else

  cat << 'EOF' > $FILE_NAME
{
  "configurations": {
    "run": {
      "adapter": "vscode-go",
      "configuration": {
        "args": [ "-conf-dir","conf" ],
        "request": "launch",
        "program": "${fileDirname}",
        "mode": "debug",
        "dlvToolPath": "$HOME/go/bin/dlv"     
       }
    } 
  }
}
EOF

fi

sed -i "s#FuncName#$1#g" $FILE_NAME
