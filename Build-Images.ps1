docker build -t mission_scheduler -f Dockerfile-MissionScheduler .
docker build -t mission_creator   -f Dockerfile-MissionCreator   .
docker build -t mission_control   -f Dockerfile-MissionControl   .
docker build -t agent             -f Dockerfile-Agent            .