$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

try {
	$CurrentAzCopy = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Azure Storage Tools*"}
	if( -not [bool] $CurrentAzCopy ) {
		throw "Please install the AzCopy and try again."
	}
	$global:AzCopyPath = "`"" +  [string]$CurrentAzCopy.InstallLocation + "AzCopy\AzCopy.exe`""
	$AzCopyPath = $global:AzCopyPath
	$AccountName = getConfValue "AccountName"
	$AccountKey = getConfValue "AccountKey"
    $input = read-host " The AzCopy located at $AzCopyPath, correct?`n (Y)es, (N)o"
    if ($input -eq "n") {
        throw "Please modify the configuration.txt and try again."
    }
	#$AzCopyCmdProcess = Start-Process cmd -ArgumentList ("/k", $AzCopyPath, "/?") -PassThru
	#$input = read-host " The AzCopy output the help, correct?`n (Y)es, (N)o"
	#$AzCopyCmdProcess | Stop-Process
 #   if ($input -eq "n") {
 #       throw "Please check if the AzCopy is installed correctly."
 #   }
}
finally {
    popd
}