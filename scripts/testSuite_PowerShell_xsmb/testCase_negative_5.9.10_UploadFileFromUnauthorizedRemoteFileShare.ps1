#doc: http://sharepoint/sites/CIS/storage/Project%20Documents/2014/XClient/Powershell/xSMB.Powershell.Cmdlets.Test.Plan.docx

Param ([ref]$result)

. ..\utility.ps1

$name = getConfValue "accountName"
$key = getConfValue "accountKey"

$r = get-random 10000
$shareName = "testshare$r"
$shareName2 = "testshare2$r"


#create a file share
$c = New-AzureStorageContext $name $key
$share = $c | new-AzureStorageShare $shareName
$share2 = $c | new-AzureStorageShare $shareName2

#mount a file share'
net use * /delete /y
net use z: \\$name.file.core.windows.net\$shareName /u:$name $key

#create a file in the file share
ni -path z:\test.file -type file -value "content"

#unmount it
net use * /delete /y

log "sleep 30 seconds"
sleep 30

#upload the file without using the name and key
$share2 | Set-AzureStorageFileContent -Source \\$name.file.core.windows.net\$shareName\test.file -Path test.file2 -force


#ask user
$y = yesOrNo "Did you see any error indicating the remote file share cannot be accessed?"
if ($y -eq "y") {
    $result.value = $true
} else {
    $result.value = $false
}


#cleanup:
#1. the file share
$share | Remove-AzureStorageShare -confirm:$false
$share2 | Remove-AzureStorageShare -confirm:$false