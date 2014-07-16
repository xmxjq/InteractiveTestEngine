#doc: http://sharepoint/sites/CIS/storage/Project%20Documents/2014/XClient/Powershell/xSMB.Powershell.Cmdlets.Test.Plan.docx

Param ([ref]$result)

. ..\utility.ps1

$name = getConfValue "accountName"
$key = getConfValue "accountKey"

$r = get-random 10000
$shareName = "testshare$r"


#create a file share
$c = New-AzureStorageContext $name $key
$share = $c | new-AzureStorageShare $shareName

#mount a file share'
net use * /delete /y
net use z: \\$name.file.core.windows.net\$shareName /u:$name $key

#create a 10MB file
$s = new-object system.io.filestream -ArgumentList z:\test.file,createnew
$s.SetLength((10 * 1024 * 1024))
$s.close()

rm c:\1.vhd

Read-host "Please run diskpart in commandline window"
write-host "Please run the following commands in diskpart window:"
write-host "create vdisk file=`"c:\1.vhd`" maximum=10"
write-host "sel vdisk file=c:\1.vhd"
write-host "attach vdisk"
write-host "create partition primary"
write-host "format fs=ntfs quick"
write-host "assign letter=m:"
Read-host "Press Enter when m: is mounted"


#download this file to target disk
$share | Get-AzureStorageFileContent -path test.file -destination m:\test.file -Force

$input = yesOrNo "Did you see any error indicating the file downloading has failed due to disk full?"

if ($input -eq "y") {
    $result.value = $true
} else {
    $result.value = $false
}

#cleanup
$share | remove-azureStorageShare -confirm:$false
net use * /delete /y

Read-host "Please run diskpart in the same commandline window"
write-host "Please run the following command in diskpart window:"
write-host "detach vdisk"
Read-host "Press Enter when comleted"

rm c:\1.vhd