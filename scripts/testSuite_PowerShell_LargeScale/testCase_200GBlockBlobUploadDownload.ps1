#doc: http://sharepoint/sites/CIS/storage/Project%20Documents/2014/XClient/Powershell/xSMB.Powershell.Cmdlets.Test.Plan.docx

Param ([ref]$result)

. ..\utility.ps1

$name = getConfValue "accountName"
$key = getConfValue "accountKey"
$disk = getConfValue "1TBDisk"

$r = get-random 10000
$containerName = "testcontainer$r"


#create a blob container
$c = New-AzureStorageContext $name $key
$container = $c | new-azureStorageContainer $containerName

pushd $disk

#create a 200000MB file
$s = new-object system.io.filestream -ArgumentList test.file,createnew
$s.SetLength((200000 * 1024 * 1024))
$s.close()

#upload this file
$container | set-azurestorageblobcontent -file test.file -blobType page

rm test.file

#download this file
$container | get-AzureStorageBlobContent -blob test.file -force

if (Test-Path test.file) {
    $result.value = $true
} else {
    $result.Value = $false
}


#cleanup:
rm test.file
$container | remove-azurestorageContainer -confirm:$false

popd