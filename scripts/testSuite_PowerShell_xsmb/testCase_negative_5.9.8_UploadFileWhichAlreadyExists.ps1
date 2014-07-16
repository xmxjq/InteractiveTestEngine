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

#create a file in the file share
ni -path z:\test.file -type file -value "oldContent"

#create a local file with same name but different content
rm test.file
ni test.file -type file -value "newContent"

ack "Please choose NO to overwrite the file"

#upload this file
$share | Set-AzureStorageFileContent -Source test.file 

#check the file content is still old
$content = gc z:\test.file
log "Content: $content"
if ($content -eq "oldContent") {
    $result.value = $true
} else {
    $result.value = $false
}


#cleanup:
#1. local file
rm test.file
#2. the file share
$share | Remove-AzureStorageShare -confirm:$false