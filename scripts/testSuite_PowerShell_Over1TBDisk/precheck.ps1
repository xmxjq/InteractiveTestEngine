$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

try {
    $account = getConfValue "AccountName"
    $input = yesOrNo "This machine has a disk which has over 1TB free space?"
    if ($input -eq "n") {
        throw "This is not expected environment. We need to quit."
    }

}
finally {
    popd
}