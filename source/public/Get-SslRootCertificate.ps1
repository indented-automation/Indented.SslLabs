function Get-SslRootCertificate {
    [CmdletBinding()]
    param( )

    $uri = '{0}/{1}' -f $Script:config.ApiEntryPoint, 'getRootCertsRaw'
    try {
        $rootCertificates = Invoke-RestMethod -Uri $uri
        [RegEx]::Matches(
            $rootCertificates,
            '-----BEGIN CERTIFICATE-----(\n(.+\n)*?)-----END CERTIFICATE-----'
        ) | ForEach-Object {
            New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(
                ,[Convert]::FromBase64String($_.Groups[1].Value)
            )
        }
    } catch {
        throw
    }
}