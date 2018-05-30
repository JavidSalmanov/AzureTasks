
Configuration Main
{

    Param ( [string] $nodeName, 
        [string] $file1,
        [string] $file2 
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
        xRemoteFile Site1ZipFile {
            Uri             = "$file1"
            DestinationPath = "C:\Scripts\Script1.sh"
            MatchSource     = $true
            DependsOn       = "[File]Scripts"
        }
        xRemoteFile Site2ZipFile {
            Uri             = "$file2"
            DestinationPath = "C:\Scripts\Script2.sh"
            MatchSource     = $true
            DependsOn       = "[File]Scripts"
        }
    }
}
