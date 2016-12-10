function Get-SslEndPointData {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('host')]
        [String]$Hostname,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [IPAddress]$IPAddress,

        [Switch]$FromCache
    )

    begin {
        $params = @{
            Uri         = '{0}/{1}' -f $Script:config.ApiEntryPoint, 'getEndpointData'
            ContentType = 'json'
        }
    }

    process {
        $Body = @{
            host      = $Hostname
            s         = $IPAddress
            fromCache = @('off', 'on')[$FromCache.ToBool()]
        }
        $restResponse = Invoke-RestMethod @params -Body $Body
        if ($null -ne $restResponse.details.hostStartTime) {
            $restResponse.details.hostStartTime = (Get-Date 01/01/1970) + 
                (New-Object TimeSpan($restResponse.details.hostStartTime * 10000))
        }
        $restResponse
    }
}