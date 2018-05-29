Configuration Main
{

    Param ( [string] $nodeName, 
        [string] $website1,
        [string] $website2 
    )

    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $nodeName
    {
        File site1Folder {
            Type            = 'Directory'
            DestinationPath = 'C:\inetpub\site1'
            Ensure          = "Present"
        }
        File site2Folder {
            Type            = 'Directory'
            DestinationPath = 'C:\inetpub\site2'
            Ensure          = "Present"
            DependsOn       = "[File]site1Folder"
        }
        xRemoteFile Site1ZipFile {
            Uri             = "$website1"
            DestinationPath = "C:\Software\site1.zip"
            MatchSource     = $true
            DependsOn       = "[File]site2Folder"
        }
        xRemoteFile Site2ZipFile {
            Uri             = "$website2"
            DestinationPath = "C:\Software\site2.zip"
            MatchSource     = $true
            DependsOn       = "[xRemoteFile]Site1ZipFile"
        }
        Archive site1 {
            Ensure      = "Present"
            Path        = "C:\Software\site1.zip"
            Destination = "C:\inetpub\site1"
            DependsOn   = "[xRemoteFile]Site2ZipFile"
        }
        Archive site2 {
            Ensure      = "Present"
            Path        = "C:\Software\site2.zip"
            Destination = "C:\inetpub\site2"
            DependsOn   = "[Archive]site1"
        }
        WindowsFeature WebServerRole {
            Name      = "Web-Server"
            Ensure    = "Present"
            DependsOn = "[Archive]site2"
        }
        xWebsite DefaultSite {
            Ensure       = "Present"
            Name         = "Default Web Site"
            State        = "Stopped"
            PhysicalPath = "C:\inetpub\wwwroot"
            DependsOn    = "[WindowsFeature]WebServerRole"
        }
        WindowsFeature WebManagementConsole {
            Name      = "Web-Mgmt-Console"
            Ensure    = "Present"
            DependsOn = "[xWebsite]DefaultSite"
        }
        WindowsFeature ASPNet45 {
            Name      = "Web-Asp-Net45"
            Ensure    = "Present"
            DependsOn = "[xWebsite]DefaultSite"
        }
        xWebAppPool site1Pool { 
            Name   = "firstwebpool"
            Ensure = "Present"
            State  = "Started"
            DependsOn = "[WindowsFeature]ASPNet45"
        } 
        xWebsite firstWebSite {
            Ensure          = "Present"
            Name            = "First Web Site"
            State           = "Started"
            PhysicalPath    = "C:\inetpub\site1"
            ApplicationPool = "firstwebpool"
            BindingInfo     = MSFT_xWebBindingInformation {
                Protocol = "http"
                Port     = 8080
            }
            DependsOn       = "[xWebAppPool]site1Pool"
        }
        xWebAppPool site2Pool { 
            Name   = "secondwebpool"
            Ensure = "Present"
            State  = "Started"
        } 
        xWebsite secondWebSite {
            Ensure          = "Present"
            Name            = "Second Web Site"
            State           = "Started"
            PhysicalPath    = "C:\inetpub\site2"
            ApplicationPool = "secondwebpool"
            BindingInfo     = MSFT_xWebBindingInformation {
                Protocol = "http"
                Port     = 8081
            }
            DependsOn       = "[xWebAppPool]site2Pool"
        }
    }
}