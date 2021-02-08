param (
[string]$repo = $(throw "Repo param in the format owner/repo is required. e.g. github/actions"),
[string]$githubPAT = $( Read-Host -asSecureString "Enter GitHub Personal Access Token" )
)

Write-Output "Download ZIP"
# Create a folder under the drive root
# mkdir \actions-runner ; cd \actions-runner
# Download the latest runner package
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.276.1/actions-runner-win-x64-2.276.1.zip -OutFile actions-runner-win-x64-2.276.1.zip

Write-Output "EXTRACT ZIP"
# Extract the installer
Add-Type -AssemblyName System.IO.Compression.FileSystem ; 
[System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\actions-runner-win-x64-2.276.1.zip", "$PWD")


Write-Output "GET TOKEN"
Write-Output "https://api.github.com/repos/$repo/actions/runners/registration-token"

$runnerToken = (Invoke-WebRequest -UseBasicParsing -Headers @{ "Accept" = "application/vnd.github.v3+json";"Authorization" = "Token $githubPAT" } -Method POST -Uri "https://api.github.com/repos/$repo/actions/runners/registration-token" |
ConvertFrom-Json |
Select token).token

# Write-Output "This is runnertoken: " $runnerToken

# Write-Output $repo $githubPAT

Write-Output "config"
.\config.cmd --url https://github.com/$repo --token $runnerToken

Write-Output "RUN"
.\run.cmd;
