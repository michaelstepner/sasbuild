# v0.2.0, by Michael Stepner, 2017-07-21
param(
	[Parameter(Mandatory=$true)][string]$build,
	[switch]$force,
	[switch]$dryrun
)

# Config
$sas_exe = "C:\Program Files\SASHome\SASFoundation\9.3\sas.exe"
$sas_cfg = "C:\Program Files\SASHome\SASFoundation\9.3\sasv9.cfg"

# Code
function runsas ($file) {
	Write-Host ((Get-Date).ToString() + " Running: " + $file + ".sas")
	if (!$dryrun) {
		& $sas_exe -CONFIG $sas_cfg -SYSIN ($file + ".sas") -LOG ($file + ".log") -PRINT ($file + ".lst") -NOSPLASH | Out-Null
		if ($LastExitCode -gt 1) {
			Move-Item -Path ($file + ".log") -Destination ($file + ".error.log") -Force
			Write-Host ((Get-Date).ToString() + " Error encountered while running " + $file + ".sas")
			exit $LastExitCode
		}
		return (ls ($file + ".log")).LastWriteTime
	}
	else {
		return Get-Date
	}
}

$firstfile = 1
Write-Host ((Get-Date).ToString() + " Build Started")
foreach($file in Get-Content $build) {

	if (!(Test-Path ($file + ".sas"))) {
		throw [System.IO.FileNotFoundException] ($file + ".sas not found")
	}
	elseif ($force) {
		$lastlogdate = runsas -file $file
	}
	elseif (!(Test-Path ($file + ".log"))) {
		$lastlogdate = runsas -file $file
	}	
	elseif ( (ls ($file + ".sas")).LastWriteTime -gt (ls ($file + ".log")).LastWriteTime ) {
		$lastlogdate = runsas -file $file
	}
	elseif ($firstfile -eq 0) {
		if ($lastlogdate -gt (ls ($file + ".log")).LastWriteTime) {
			$lastlogdate = runsas -file $file
		}
	}
	
	$firstfile = 0

}
Write-Host ((Get-Date).ToString() + " Build Ended")
