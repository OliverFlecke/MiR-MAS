$isRunning = docker ps --filter 'name=rabbit' -q

if (!$isRunning) {
    Write-Host "The rabbit is not running."
    if (docker ps --filter 'name=rabbit' -aq) {
        Write-Host "Removing old container"
        docker stop rabbit
        docker rm rabbit
    }

    Write-Host "Starting RabbitMQ container..."
    docker run -d --hostname rabbit --name rabbit -p 8080:15672 -p 5672:5672 rabbitmq:3-management-alpine
} else {
    Write-Host "RabbitMQ is already running. Container Id: $isRunning"
}
