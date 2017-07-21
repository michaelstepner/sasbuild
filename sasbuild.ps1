param(
	[Parameter(Mandatory=$true)][string]$build
)

function runsas ($file) {
	Write-Host ((Get-Date).ToString() + " Running: " + $file + ".sas")
	& "C:\Program Files\SASHome\SASFoundation\9.3\sas.exe" -CONFIG "C:\Program Files\SASHome\SASFoundation\9.3\sasv9.cfg" -SYSIN ($file + ".sas") -LOG ($file + ".log") -PRINT ($file + ".lst") -NOSPLASH | Out-Null
	if ($LastExitCode -gt 1) {
		Move-Item -Path ($file + ".log") -Destination ($file + ".error.log") -Force
		Write-Host ((Get-Date).ToString() + " Error encountered while running " + $file + ".sas")
		exit $LastExitCode
	}
}

$firstfile = 1
Write-Host ((Get-Date).ToString() + " Build Started")
foreach($file in Get-Content $build) {

	if (!(Test-Path ($file + ".sas"))) {
		throw [System.IO.FileNotFoundException] ($file + ".sas not found")
	}
	elseif (!(Test-Path ($file + ".log"))) {
		runsas -file $file
	}	
	elseif ( (ls ($file + ".sas")).LastWriteTime -gt (ls ($file + ".log")).LastWriteTime ) {
		runsas -file $file
	}
	elseif ($firstfile -eq 0) {
		if ($lastlogdate -gt (ls ($file + ".log")).LastWriteTime) {
			runsas -file $file
		}
	}
	
	$firstfile = 0
	$lastlogdate = (ls ($file + ".log")).LastWriteTime

}
Write-Host ((Get-Date).ToString() + " Build Ended")
