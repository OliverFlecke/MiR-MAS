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

Write-Host "Cleaning up old containers"
./Clean.ps1 -Unity=$Unity
Write-Host ""

if ($Unity) {
    MiR-Simulator/build/MiR-Simulator map ./MAS.Shared/maps/$Map
}

./Run-RabbitMQ.ps1
./Run-Statistics.ps1 -Map $Map -DotnetVersion $DotnetVersion
./Run-MissionControl.ps1 -Containers:$Containers -DotnetVersion $DotnetVersion

if ($NoAgents)
{
    Write-Host "Skipping agent creation"
}
else
{
    ./Run-Agents.ps1 -Map $Map -Containers:$Containers -Centralized:$Centralized -DotnetVersion $DotnetVersion
}

Start-Sleep -Seconds 2
./Run-MissionCreator.ps1 -Map $Map -Containers:$Containers -Schedule $Schedule -DotnetVersion $DotnetVersion