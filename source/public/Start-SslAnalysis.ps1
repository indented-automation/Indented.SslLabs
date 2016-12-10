function Start-SslAnalysis {
    # .SYNOPSIS
    #   Start an SSLLabs analysis request.
    # .DESCRIPTION
    #   Start an SSLLabs analysis request. Once started the request will sit in a processing state until complete.
    #
    #   Once started, subsequent calls to this command will show the updated state of the request.
    # .INPUTS
    #   System.String
    # .OUTPUTS
    #   System.Management.Automation.PSObject
    # .NOTES
    #   Author: Chris Dent
    #
    #   Change log:
    #     09/12/2016 - Chris Dent - Created.

    [CmdletBinding()]
    param(
        [String[]]$Hostname,

        [Switch]$Publish,

        [Switch]$FromCache,

        [Switch]$IgnoreMismatch,

        [Switch]$Wait
    )

    begin {
        $params = @{
            Uri         = '{0}/{1}' -f $Script:config.ApiEntryPoint, 'analyze'
            ContentType = 'json'
        }

        $jobs = New-Object System.Collections.Generic.List[PSObject]
    }

    process {
        foreach ($name in $hostname) {
            $Body = @{
                host           = $name
                publish        = @('off', 'on')[$Publish.ToBool()]
                fromCache      = @('off', 'on')[$FromCache.ToBool()]
                ignoreMismatch = @('off', 'on')[$IgnoreMismatch.ToBool()] 
            }
            $restResponse = Invoke-RestMethod @params -Body $Body
            foreach ($property in $restResponse.PSObject.Properties) {
                if ($property.Name.EndsWith('Time')) {
                    $property.Value = (Get-Date 01/01/1970) + (New-Object TimeSpan($property.Value * 10000))
                }
            }
            if ($Wait) {
                $null = $jobs.Add($restResponse)
            } else {
                $restResponse
            }
        }
    }

    end {
        if ($Wait) {
            $jobs | Wait-SslAnalysis
        }
    }
}