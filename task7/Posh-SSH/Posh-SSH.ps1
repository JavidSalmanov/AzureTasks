Install-Module -Name Posh-SSH
$Credential = Get-Credential
$ComputerName = 'janewvm002.westeurope.cloudapp.azure.com'
$RemoteFile = "/home/javidadm/test"
$LocalPath = "$home\desktop"
$RemoteFolder = "/home/javidadm/ja"
$Command = "sudo apt-get -y install htop"
$LocalFile = "$home\desktop\posh-ssh.ps1"
$Script = "$home\desktop\script.sh"
$ExecPermission = "sudo chmod +x /home/javidadm/ja/script.sh"
$SSHSession = New-SSHSession -ComputerName $ComputerName -AcceptKey -Credential $Credential
$SFTPSession = New-SFTPSession -ComputerName $ComputerName -Credential $Credential
Invoke-SSHCommand -SSHSession $SSHSession -Command $Command #execute command in remote server
Get-SCPFolder -ComputerName $ComputerName -Credential $Credential -LocalFolder $LocalPath -RemoteFolder $RemoteFolder #download folder files from remote computer
Get-SFTPFile -SFTPSession $SFTPSession -RemoteFile $RemoteFile -LocalPath $LocalPath   # Download file from remote computer
Set-SCPFile -ComputerName $ComputerName -Credential $Credential -Port 22 -LocalFile $LocalFile -RemotePath $RemoteFolder #UploadFile to Remote Computer
Set-SCPFolder -ComputerName $ComputerName -Credential $Credential -Port 22 -LocalFolder $LocalPath -RemoteFolder $RemoteFolder #UploadFolder to Remote Computer

Set-SCPFile -ComputerName $ComputerName -Credential $Credential -Port 22 -LocalFile $Script -RemotePath $RemoteFolder
Invoke-SSHCommand -SSHSession $SshSessions -Command $ExecPermission
Invoke-SSHCommand -SSHSession $SshSessions -Command "/home/javidadm/ja/script.sh"