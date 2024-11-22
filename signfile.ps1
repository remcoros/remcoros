param (
    [string]$url
)

# Define the GPG Key ID to use for signing
$keyId = "2F5B10B929CAC959"

# Check if the URL is provided
if (-not $url) {
    Write-Host "Usage: .\SignFile.ps1 <url>"
    exit 1
}

# Extract the filename from the URL
$filename = [System.IO.Path]::GetFileName($url)

# Download the file
Write-Host "Downloading $filename from $url..."
Invoke-WebRequest -Uri $url -OutFile $filename

if (-not (Test-Path $filename)) {
    Write-Host "Error: Failed to download the file."
    exit 1
}

Write-Host "File downloaded: $filename"

# Sign the file using GPG
$signatureFile = "$filename.asc"
Write-Host "Signing the file using GPG key ID: $keyId..."
gpg --detach-sign --armor -u $keyId -o $signatureFile $filename

# Check if the signature file was created
if (Test-Path $signatureFile) {
    Write-Host "File signed successfully. Signature saved as $signatureFile"
} else {
    Write-Host "Error: Failed to sign the file."
    exit 1
}
