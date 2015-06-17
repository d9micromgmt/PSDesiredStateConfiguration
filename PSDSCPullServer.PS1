configuration PSDSCPullServer
{
    param 
    (
        [valditatenotnullorempty()]
        [String] $certificatethumbprint
    )

    Import-DSCResource -modulename DSCService

    Node localhost
    {
        windowsfeature DSCServiceFeature
        {
            Ensure = "Present"
            Name = "DSC-Service"
        }

        DSCService PSDSCPullServer
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
