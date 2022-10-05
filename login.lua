
echo(true)
if spawn([[c:\Program Files\Git\usr\bin\ssh.exe]],"vagrant@192.168.56.100") then
    expect("password:")
    echo(false)
    send("vagrant\r")
    expect("~]$")
    echo(true)
    send("exit\r")
end
