$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

try {
    $account = getConfValue "AccountName"
    $input = read-host " This is an Azure VM in the same data center as this storage account $account, correct?`n (Y)es, (N)o"
    if ($input -eq "n") {
        throw "This is not expected environment. We need to quit."
    }

}
finally {
    popd
}