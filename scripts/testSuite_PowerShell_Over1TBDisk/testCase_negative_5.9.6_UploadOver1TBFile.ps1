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

$input = read-host "Which disk has over 1TB free space? (e.g. x:)"

pushd $input

#create a 1025GB file
$s = new-object system.io.filestream -ArgumentList test.file,createnew
$s.SetLength((1025 * 1024 * 1024 * 1024))
$s.close()

#upload this file
$share | Set-AzureStorageFileContent -Source test.file -force

$y = yesOrNo "Did you see any error that file uploading failed?"

if ($y -eq "y") {
    $result.value = $true
} else {
    $result.value = $false
}


#cleanup:
#1. local file
rm test.file
#2. the file share
$share | Remove-AzureStorageShare -confirm:$false

popd