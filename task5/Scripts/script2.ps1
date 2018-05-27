param(
    [string]$filename
)
New-Item -Path "C:\Users\javidadm\Desktop" -Name $filename -ItemType File
Write-Output "This is test file" > "C:\Users\javidadm\Desktop\JavidTestFile.txt"

