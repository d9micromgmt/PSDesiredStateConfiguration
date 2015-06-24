Install-Package xPSDesiredStateConfiguration -Force -ForceBootstrap

configuration PSDSCPullServer
{
    param 
    (
        [Parameter()]
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
            EndpointName            = "PSDSCPullServer"
            Port                    = "8080"
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbprint   = $certificatethumbprint
            ModulePath              = "$env:ProgramFiles\windowspowershell\DscService\Modules"
            ConfigurationPath       = "$env:ProgramFiles\windowspowershell\DscService\Configuration"
            state                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"
            RegistrationKeyPath     = "$env:PROGRAMFILES\WindowsPowerShell\DscService"   
            AcceptSelfSignedCertificates = $true
        }
    }
}
