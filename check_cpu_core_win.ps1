$warning = 80 #$args[0]
$critical = 90 #$args[1]

$ok_count= 0
$wr_count= 0
$cr_count= 0

$cores = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Select Name, PercentProcessorTime)

$cpucores_array = @()
foreach ($core in $cores)
    {
        $cpucore = $core.PercentProcessorTime
        if ($core.Name -eq "_Total") {continue}
        $cpucores_array += $cpucore
    }
	
foreach ($core in $cpucores_array)
    {
        if ($core -ge $critical) {$cr_count += 1}
        elseif ($core -ge $warning) {$wr_count += 1}
            else {$ok_count += 1}
    }
	
Write-Host "CRITICAL - $cr_count core(s) WARNING - $wr_count core(s) OK - $ok_count core(s)"
$cores | foreach-object { write-host "cpu$($_.Name): $($_.PercentProcessorTime)% | cpu$($_.Name)=$($_.PercentProcessorTime)%;;;0;100"};

if ($cr_count -gt 0) { [System.Environment]::Exit(2) }
elseif ($wr_count -gt 0) { [System.Environment]::Exit(1) }
	else { [System.Environment]::Exit(0) }