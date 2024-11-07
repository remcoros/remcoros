$keyId = "2F5B10B929CAC959"

Remove-Item -Path manifest.txt -ErrorAction SilentlyContinue
Remove-Item -Path manifest.txt.asc -ErrorAction SilentlyContinue

$files = foreach ($arg in $args) {
    Get-ChildItem -Path $arg -File
}

$files | ForEach-Object {
    $hashResult = Get-FileHash -Algorithm SHA256 $_.FullName
    "$($hashResult.Hash) $($_.Name)"
} | Out-File -FilePath manifest.txt -Encoding utf8NoBOM

gpg --detach-sign --armor -u $keyId -o manifest.txt.asc manifest.txt
