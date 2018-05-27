param(
    [string] $foldername,
    [string] $filename
)
$exp1 = "C:\Scripts\script1.ps1 -foldername $foldername"
$exp2 = "C:\Scripts\script2.ps1 -filename $filename"
Invoke-Expression $exp1
Invoke-Expression $exp2

