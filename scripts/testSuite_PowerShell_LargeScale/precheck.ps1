$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

try {
    $account = getConfValue "AccountName"
    $disk = getConfValue "1TBDisk"
    $y = yesOrNo "This machine has a disk $disk which has over 1TB free space?"
    if ($y) {
        throw "This is not expected environment. We need to quit."
    }
}
finally {
    popd
}