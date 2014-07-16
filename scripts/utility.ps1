function log ($message) {
    $d = get-date
    write-host ("[{0:yyyy-MM-dd HH:mm:ss}] $message" -f $d)
}

function getConfValue ($key) {
    $c = gc "configuration.txt"

    $c | % {
        if ($_ -like "$key=*") {
            $startIndex = "$key=".Length
            $value = $_.substring($startIndex)
            return $value
        }
    }
}

function ack ($info) {
    do {
        $input = Read-Host "[ATTENTION!] $info. `r`n(Y) Ok, I get that.`n(N) Sorry, what did you say? `nYou"
    } while ($input -ne "y")
}

function yesOrNo($info) {
    do {
        $input = Read-Host "[ATTENTION!] $info. `r`n(Y)es `n(N)o.`nYou"

        if ($input -eq "n") {
            return $false
        } elseif ($input -eq "y") {
            return $true
        }
    } while ($true)
}