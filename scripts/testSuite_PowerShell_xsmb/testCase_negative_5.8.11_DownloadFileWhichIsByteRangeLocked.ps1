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

#create a file with content
ni z:\test.file -type File -value "content"

#access a file and lock it
$s = new-object system.io.filestream -ArgumentList z:\test.file,Open,readwrite,write
$s.Lock(0, 1)

#download this file to current directory
$share | Get-AzureStorageFileContent -path test.file -Force

$result.value = $true
if (Test-Path test.file) {
    $content = gc test.file

    if ($content -eq "content") {
        log "File is downloaded. Content: $content"
        log "It should not be downloaded"

        $result.value = $false
    }
}


#remove it
$share | remove-azureStorageShare -confirm:$false
net use * /delete /y