param(
    [switch]
    $Containers,
    [String]
    [ValidateSet('3.0', '2.2')]
    $DotnetVersion = '3.0'
)

if ($Containers)
{
    Write-Host "Starting Mission Control - Docker"
    docker run -d --name mission_control --net="host" mission_control
}
else
{
    Write-Host "Starting Mission Control"
    start powershell "dotnet ./MAS.MissionControl/bin/Debug/netcoreapp$DotnetVersion/MAS.MissionControl.dll"
}