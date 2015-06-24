Install-Package xPSDesiredStateConfiguration -Force -ForceBootstrap

configuration PSDSCPullServer
{
    param 
    (
        [valditatenotnullorempty()]
        [String] $certificatethumbprint
    )

    Import-DSCResource -modulename xPSDesiredStateConfiguration

    Node localhost
    {
        windowsfeature DSCServiceFeature
        {
            Ensure = "Present"
            Name = "DSC-Service"
        }

        xDSCWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            Name                    = "PSDSCPullServer"
            Port                    = "8080"
            PhsyicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            EnableFirewallException = $true
            CertificateThumbprint   = $certificatethumbprint
            ModulePath              = "$env:ProgramFiles\windowspowershell\DscService\Modules"
            ConfigurationPath       = "$env:ProgramFiles\windowspowershell\DscService\Configuration"
            state                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"
        }
    }
}
