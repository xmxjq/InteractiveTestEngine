#doc: http://sharepoint/sites/CIS/storage/Project%20Documents/2014/XClient/Powershell/xSMB.Powershell.Cmdlets.Test.Plan.docx

Param ([ref]$result)

. ..\utility.ps1

$name = getConfValue "accountName"
$key = getConfValue "accountKey"
$disk = getConfValue "1TBDisk"

$r = get-random 10000
$shareName = "testshare$r"


#create a file share
$c = New-AzureStorageContext $name $key
$share = $c | new-AzureStorageShare $shareName

pushd $disk

#create a 1024GB file
$s = new-object system.io.filestream -ArgumentList test.file,createnew
$s.SetLength((1024 * 1024 * 1024 * 1024))
$s.close()

#upload this file
$share | Set-AzureStorageFileContent -Source test.file -force

rm test.file

#download this file
$share | get-AzureStorageFileContent -path test.file -force

if (Test-Path test.file) {
    $result.value = $true
} else {
    $result.Value = $false
}



#cleanup:
#1. local file
rm test.file
#2. the file share
$share | Remove-AzureStorageShare -confirm:$false

popd