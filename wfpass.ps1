# Define the output file path dynamically
$outputFile = Join-Path -Path $env:USERPROFILE -ChildPath "Desktop\Wifi Extraction.txt"

# Run the command and save the output to the file
netsh wlan show profile |
    Select-String '(?<=All User Profile\s+:\s).+' |
    ForEach-Object {
        $wlan = $_.Matches.Value
        $passw = netsh wlan show profile $wlan key=clear |
            Select-String '(?<=Key Content\s+:\s).+'

        [pscustomobject]@{
            Name     = $wlan
            Password = $passw.Matches.Value
        }
    } | Format-Table -AutoSize | Out-File -FilePath $outputFile
