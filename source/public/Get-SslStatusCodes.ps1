function Get-SslStatusCodes {
    [CmdletBinding()]
    param( )

    $uri = '{0}/{1}' -f $Script:config.ApiEntryPoint, 'getStatusCodes'
    (Invoke-RestMethod -Uri $uri).statusDetails
}