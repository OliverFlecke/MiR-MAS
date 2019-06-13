param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [String]
    [ValidateSet('3.0', '2.2')]
    $DotnetVersion = '3.0'
)

start powershell "dotnet ./MAS.Statistics/bin/Debug/netcoreapp$DotnetVersion/MAS.Statistics.dll ./MAS.Shared/maps/$Map"
