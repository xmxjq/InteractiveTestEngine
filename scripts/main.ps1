function main {
    $choice = ""
    selectTestSuite ([ref]$choice)


    if (-not (runPrecheck $choice)) {
        log "precheck failed. exiting."
        return
    }
    
    log "Begin running test cases"

    $script:results = @()
    $script:total = 0

    pushd $choice
    try {
        $files = dir "testCase_*.ps1" -File -ErrorAction Ignore
        $files | % {
            try {
                log "Running $($_.FullName)"

                log $_.Name
                $tcName = $_.Name.Substring(9,($_.Name.Length - 4 - 9))
                $result = $false
                &$_.FullName ([ref]$result)

                $script:total++
                if ($result -ne $null) {
                    $script:results += @($tcName,$result)
                    log "$tcName : $result"
                }

                log "===================================================="
            } catch {
                log "[Investigate] Test Case $_ terminated unexpected."
            }
        }

        generateReport $script:results $script:total

        read-host "Press Enter to exit"
    } finally {
        popd
    }
}

function generateReport ($results, $total) {
    $failedCases = @()

    for ($i = 0; $i -lt $results.Length; $i += 2) {
        $case = $results[$i]
        $result = $results[$i + 1]

        if ($result -eq $false) {
            $failedCases += $case
        }

        $s = ("Test Case {0} - {1}" -f $case,$result)
        log $s
    }

    $overall = ("{0}/{1} cases passed" -f ($total-$failedCases.count),$total)
    log $overall
    echo $overall > result.txt

    if ($failedCases.count -gt 0) {
        echo "Failed cases:" >> result.txt
        $failedCases | % { 
            echo "`t$_" >> result.txt
        }
    }
}

function selectTestSuite([ref]$choice) {
    $dirs = ls -Directory testsuite_*
    if ($dirs.count -eq 1) {
        $choice.value = $dirs[0].FullName
        return
    }

    $i = 1

    write-host "Choose one test suite:"
    $dirs | % {
        write-host "`t[$i] $($_.Name)"
        $i++
    }

    $input = read-host "Your choice"
    $choice.value = $dirs[($input - 1)].FullName
}

function runPrecheck ($folder) {
    $precheckFile = "$folder\precheck.ps1"

    if (Test-Path $precheckFile) {
        try {
            &$precheckFile 
        } catch {
            log "precheck failed. exiting: $_"
            return $false
        }
    }

    return $true
}

try {
    $root = split-path $MyInvocation.MyCommand.Path
    . $root\utility.ps1

    pushd $root

    log "start testing"
    main
} finally {
    popd
}

