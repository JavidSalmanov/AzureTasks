Configuration Main
{

    Param ( [string] $nodeName,
        [string] $customscripts1,
        [string] $customscripts2 
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $nodeName
    {
        File Scripts {
            Type            = 'Directory'
            DestinationPath = 'C:\Scripts'
            Ensure          = "Present"
        }
        xRemoteFile customscripts1 {
            Uri             = "$customscripts1"
            DestinationPath = "C:\Scripts\script1.ps1"
            MatchSource     = $true
            DependsOn       = "[File]Scripts"
        }
        xRemoteFile customscripts2 {
            Uri             = "$customscripts2"
            DestinationPath = "C:\Scripts\script2.ps1"
            MatchSource     = $true
            DependsOn       = "[File]Scripts"
        }
    }
}
