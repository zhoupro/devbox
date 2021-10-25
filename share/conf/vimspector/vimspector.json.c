{
"configurations": {
"linux debug": {
      "adapter": "vscode-cpptools",
     "configuration": {
        "request": "launch",
        "program": "/data/server/redis/bin/redis-server",
        "MIMode": "gdb",
        "stopAtEntry": true,
        "setupCommands": [
            {"text": "-gdb-set follow-fork-mode child"}
        ]
      }
     }
}}

