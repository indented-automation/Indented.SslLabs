. "$psscriptroot\InitializeModule.ps1"
InitializeModule

Get-ChildItem "$psscriptroot\public" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}