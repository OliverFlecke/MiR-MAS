./MiR-simulator/Stop-Unity.ps1

$MissionControl = docker ps --filter name=mission_control -qa
if ($MissionControl)
{
    Write-Host "Removing old Mission control containers..."
    docker stop $MissionControl
    docker rm $MissionControl
}
$MissionCreator = docker ps --filter name=mission_creator -qa
if ($MissionCreator)
{
    Write-Host "Removing old Mission creator containers..."
    docker stop $MissionCreator
    docker rm $MissionCreator
}

if (docker ps --filter name=agent -q)
{
    docker stop $(docker ps -q --filter name=agent)
}
if (docker ps --filter name=agent -qa)
{
    Write-Host "Removing old agent containers"
    docker rm $(docker ps -aq --filter name=agent)
}
