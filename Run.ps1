param(
    # The file to launch the simulator with
    [Parameter(Mandatory=$true)]
    [String]
    $Map,
    [switch]
    $Unity,
    [switch]
    $Containers,
    [switch]
    $NoMissionContainers,
    [string]
    $Schedule,
    [switch]
    $NoAgents,
    [switch]
    $Centralized,
    [String]
    [ValidateSet('3.0', '2.2')]
    $DotnetVersion = '3.0'
)

function Count-Robots([string] $Map)
{
    $FileContent = Get-Content $Map
    $Matches = Select-String -InputObject $FileContent -Pattern "r" -AllMatches
    return $Matches.Matches.Count
}

Write-Host "Cleaning up old containers"
./Clean.ps1 -Unity=$Unity
Write-Host ""

if ($Unity) {
    MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map
}

./Run-RabbitMQ.ps1
start powershell "dotnet ./MAS.Statistics/bin/Debug/netcoreapp$DotnetVersion/MAS.Statistics.dll ./MAS.Shared/maps/$Map"

Write-Host "Starting mission controller and creator"
if ($NoMissionContainers)
{
    start powershell "dotnet ./MAS.MissionControl/bin/Debug/netcoreapp$DotnetVersion/MAS.MissionControl.dll"
}
else
{
    docker run -d --name mission_control --net="host" mission_control
}

if ($NoAgents)
{
    Write-Host "Skipping agent creation"
}
elseif ($Centralized)
{
    start powershell "dotnet ./MAS.CentralizedAgents/bin/Debug/netcoreapp$DotnetVersion/MAS.CentralizedAgents.dll ./MAS.Shared/maps/$Map"
}
else
{
    $Robots = Count-Robots("./MAS.Shared/maps/$Map")
    for ($i = 0; $i -lt $Robots; $i++) {
        Write-Host "Creating robot $i"
        if ($Containers)
        {
            docker run -d --name="agent$i" --net="host" agent $Map $i
        }
        else
        {
            start powershell "dotnet ./MAS.Agents/bin/Debug/netcoreapp$DotnetVersion/MAS.Agents.dll ./MAS.Shared/maps/$Map $i"
        }
    }
}

Start-Sleep -Seconds 2
if ($NoMissionContainers)
{
    if ($Schedule)
    {
        start powershell "dotnet ./MAS.MissionScheduler/bin/Debug/netcoreapp$DotnetVersion/MAS.MissionScheduler.dll ./MAS.MissionScheduler/$Schedule"
    }
    else
    {
        start powershell "dotnet ./MAS.MissionCreator/bin/Debug/netcoreapp$DotnetVersion/MAS.MissionCreator.dll ./MAS.Shared/maps/$Map"
    }
}
else
{
    if ($Schedule)
    {
        docker run -d --name mission_scheduler --net="host" mission_scheduler $Schedule
    }
    else
    {
        docker run -d --name mission_creator --net="host" mission_creator "./maps/$Map" $Schedule
    }
}