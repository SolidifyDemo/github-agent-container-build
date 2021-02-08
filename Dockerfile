FROM mcr.microsoft.com/windows/servercore:ltsc2019

ADD start.ps1 C:/start.ps1

WORKDIR /actions-runner

SHELL [ "powershell" ]


CMD C:\start.ps1 "$env:REPO" "$env:PAT"