$root = split-path $MyInvocation.MyCommand.Path
pushd $root 
. $root\..\utility.ps1

try {
	#do what you want to check here
	#if fails, simply throw errors like this: thows "This is not expected environment. We need to quit."
}
finally {
    popd
}