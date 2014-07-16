Param ([ref]$result)

. ..\utility.ps1

$name = getConfValue "accountName"
$key = getConfValue "accountKey"

$r = get-random 10000
$shareName = "testshare$r"

$cnt = 1000

#create a file share
$c = New-AzureStorageContext $name $key
$share = $c | new-AzureStorageShare $shareName

1..$cnt | % {
    $share | new-AzureStorageDirectory -path "d$_"
}

$dirs = $share | get-AzureStorageFile

if ($dirs.count -ne $cnt) {
    log "Not getting $cnt directories"
    log "directories:"
    $dirs | % {
        log $_
    }

    $result.value = $false
    return
}

$result.value = $true

$c | remove-azureStorageShare $shareName -confirm:$false