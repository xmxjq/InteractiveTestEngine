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

#create a local file
ni test.file -type file -value "content"
$f = ls test.file
$fn = ("\\localhost\" + $f.FullName.Replace(":","$"))

#upload this file to current directory
$share | set-AzureStorageFileContent -Source $fn -Force

if (Test-path z:\test.file) {
    $content = gc z:\test.file
    if ($content -eq "content") {
        log "File is uploaded"
        $result.value = $true
    } else {
        log "file content is incorrect: "
        log $content
        $result.value = $false
    }
} else {
    log "File is not uploade"
    $result.value = $false
}


#cleanup
rm test.file
$share | remove-azureStorageShare -confirm:$false
net use * /delete /y