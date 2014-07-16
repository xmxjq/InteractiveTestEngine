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

#create a file and lock it exclusively
$s = new-object system.io.filestream -ArgumentList z:\test.file,CreateNew,readwrite,none

#remove it
$c | remove-azureStorageShare $shareName -confirm:$false

#try to list this share again
$share = $c | get-azureStorageShare $shareName

if ($share -ne $null) {
    $result.value = $false
    return
}

$result.value = $true
net use * /delete /y