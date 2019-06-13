param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [switch]
    $Containers,
    [switch]
    $Centralized,
    [String]
    [ValidateSet('3.0', '2.2')]
    $DotnetVersion = '3.0'
)

./Run-Statistics.ps1 -Map $Map -DotnetVersion $DotnetVersion
./Run-Agents.ps1 -Map $Map -Containers:$Containers -Centralized:$Centralized -DotnetVersion $DotnetVersion
./Run-MissionControl.ps1 -Containers:$Containers -DotnetVersion $DotnetVersion

