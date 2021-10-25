{
  "configurations": {
    "run": {
      "adapter": "vscode-go",
      "configuration": {
        "args": [ "*${args: -conf-dir conf -port 8888 -log-dir logs}" ],
        "request": "launch",
        "program": "${fileDirname}",
        "mode": "debug",
        "dlvToolPath": "$HOME/go/bin/dlv"     }
    }
  }
}

