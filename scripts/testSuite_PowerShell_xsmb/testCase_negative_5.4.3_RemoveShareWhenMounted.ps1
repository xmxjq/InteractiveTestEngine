#doc: http://sharepoint/sites/CIS/storage/Project%20Documents/2014/XClient/Powershell/xSMB.Powershell.Cmdlets.Test.Plan.docx

Param ([ref]$result)

. ..\utility.ps1

$name = getConfValue "accountName"
$key = getConfValue "accountKey"

$r = get-random 10000
$shareName = "testshare$r"


#create a file share
$c = New-AzureStorageContext $name $key
$c | new-AzureStorageShare $shareName

#mount a file share'
net use * /delete /y
net use z: \\$name.file.core.windows.net\$shareName /u:$name $key

#remove it
$c | remove-azureStorageShare $shareName -confirm:$false

#try to list this share again
$share = $c | get-azureStorageShare $shareName

if ($share -ne $null) {
    $result.value = $false
    return
}

log "sleep 60 seconds"
sleep 60

#write to the file share
ni z:\test.file -Type File -Value "SomeContent"

#check results or prompt user
$input = Read-Host "Did you any error that shows the mounted disk is disconnected?"

if ($input -eq "y") {
    $result.value = $true
} else {
    $result.value = $false
}