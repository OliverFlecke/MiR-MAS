param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [switch]
    $Containers,
    [string]
    $Schedule,
    [string]
    $Ready,
    [String]
    [ValidateSet('3.0', '2.2')]
    $DotnetVersion = '3.0'
)

$Args = if ($Ready) {"ready"} else {""}

if ($Containers)
{
    if ($Schedule)
    {
        docker run -d --name mission_scheduler --net="host" mission_scheduler $Schedule $Args
    }
    else
    {
        docker run -d --name mission_creator --net="host" mission_creator "./maps/$Map" $Schedule $Args
    }
}
else
{
    if ($Schedule)
    {
        start powershell "dotnet ./MAS.MissionScheduler/bin/Debug/netcoreapp$DotnetVersion/MAS.MissionScheduler.dll ./MAS.MissionScheduler/$Schedule $Args"
    }
    else
    {
        start powershell "dotnet ./MAS.MissionCreator/bin/Debug/netcoreapp$DotnetVersion/MAS.MissionCreator.dll ./MAS.Shared/maps/$Map $Args"
    }
}