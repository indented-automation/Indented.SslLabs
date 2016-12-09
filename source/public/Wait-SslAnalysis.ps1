function Wait-SslAnalysis {
    # .SYNOPSIS
    #   Wait for analysis jobs to complete.
    # .DESCRIPTION
    #   Wait for pending SSL analysis requests to complete.
    # .INPUTS
    #   System.Management.Automation.PSObject
    # .OUTPUTS
    #   System.Management.Automation.PSObject
    # .NOTES
    #   Author: Chris Dent
    #
    #   Change log:
    #     09/12/2016 - Chris Dent - Created.

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('host')]
        [String]$Hostname
    )

    begin {
        $executingTests = New-Object System.Collections.Generic.Dictionary'[String,PSObject]'
    }

    process {
        $null = $executingTests.Add($Hostname, '')
    }

    end {
        do {
            $keys = $executingTests.Keys | ForEach-Object { $_ }
            foreach ($key in $keys) {
                $restResponse = Start-SslAnalysis -Hostname $key
                if ($restResponse.status -eq 'READY') {
                    $null = $executingTests.Remove($key)
                    
                    $restResponse
                }
            }
            if ($executingTests.Count -gt 0) {
                Start-Sleep -Seconds 10
            }
        } until ($executingTests.Count -eq 0)
    }
}