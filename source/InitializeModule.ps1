function InitializeModule {
    $Script:config = Get-Content var/config.json -Raw | ConvertFrom-Json
}