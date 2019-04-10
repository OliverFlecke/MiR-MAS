docker build -t mission_creator -f Dockerfile-MissionCreator --force-rm .
docker build -t mission_control -f Dockerfile-MissionControl --force-rm .
docker build -t agent           -f Dockerfile-Agent          --force-rm .