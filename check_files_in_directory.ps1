param([string]$Directory)
$Date = (Get-Date).AddMinutes(-5)
If (Test-Path "$Directory")
{
        $Files = Get-ChildItem "$Directory" *.* | where-object {$_.LastWriteTime -le $Date}
        $Count = $Files.count
        If ($Count -gt 0)
        {
                Write-Host "WARNING: $Directory conteins $Count old files"
                [System.Environment]::Exit(1)
        }
        Else
        {
                Write-Host "OK: $Directory doesn't contein old files"
                [System.Environment]::Exit(0)
        }
}
Else
{
        Write-Host "$Directory doesn't exist"
        [System.Environment]::Exit(1)
}