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

#create a 50MB file
$s = new-object system.io.filestream -ArgumentList z:\test.file,Open,readwrite,write
$s.SetLength((50 * 1024 * 1024))
$s.close();

ack "When file downloading is started next, please delete z:\test.file immediately."

#download this file to current directory
$share | Get-AzureStorageFileContent -path test.file -Force

$input = yesOrNo "Did you see the file download has completed without errors?"
if ($input -eq "y") {
    $result.value = $true
} elsif ($input -eq "n") {
    $result.value = $false
}

#remove it
$share | remove-azureStorageShare -confirm:$false
net use * /delete /y