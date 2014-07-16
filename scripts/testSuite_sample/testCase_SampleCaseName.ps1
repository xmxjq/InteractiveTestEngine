#Keep these two lines
Param ([ref]$result)
. ..\utility.ps1

#You can get config value like this:
#$value = getConfValue "sample"


#Do your stuff here and set $passed to $true of $false to indicate test result
$passed = $true


#Return test result
if ($passed) {
    $result.value = $true
} else {
    $result.value = $false
}