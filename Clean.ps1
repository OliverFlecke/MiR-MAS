$MissionControl = docker ps --filter "name=mission_control" -qa
if ($MissionControl)
{
    Write-Host "Removeing old Mission control containers..."
    docker stop $MissionControl
    docker rm $MissionControl
}
$MissionCreator = docker ps --filter "name=mission_creator" -qa
if ($MissionCreator)
{
    Write-Host "Removeing old Mission creator containers..."
    docker stop $MissionCreator
    docker rm $MissionCreator
}

Write-Host "Removing old agent containers"
docker stop $(docker ps -q --filter name=agent)
docker rm $(docker ps -aq --filter name=agent)
