# MiR Multi-Agent System

This repository is the mono-repository for the different applications for the MiR-MAS.
Each project contains a part of the Multi-Agent System.

Most importantly, the `MiR-simulator` contains the simulator.
This require [Unity3D](https://unity.com) to build.

`MAS.Messaging` and `MAS.Shared` contains common functionality which is shared between the other projects.
`MAS.Missions` contains the tasks or missions that agents can carryout, along with how to build plans.
`MAS.Agent` contains the main agent of the MAS.
The remaining projects are different *agents* that can be connected to the system.

The different `Run*` scripts in the root directory allows for running either the full system or part of it.
The main file is `Run.ps1`, which allows to run the full system.
An example of running a simulation is:

```powershell
Run.ps1 -Map MA/5.map -Unity
```

Note that this requires that the simulator has already been build.

## Dependencies

As mentioned, the simulator require [Unity3D](https://unity.com) to run (version 2018 has been used to build the project).
When this is installed, running the `Build.ps1` script in the `MiR-simulator` directory will build the project.

Secondly, [Docker](https://docker.com) is used to run [RabbitMQ](https://rabbitmq.com), the message broker to handle communication in the MAS.
If Docker is installed, RabbitMQ will be started by the `Run.ps1` script.
Note that it usually takes a few seconds before it starts responding.
