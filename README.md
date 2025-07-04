# docker_management

## Env

It is recommended to use the provided Conda dependency file to create a virtual environment for running the Bash script.
```
./envs/build-snv.sh

conda activate dockerctl
```


## Use

**run image**

This is a convenient script for creating a container that supports GUI display and GPU access.

```
. run-docker.sh
```
**build dockerfile**

```
. build-dockerfile.sh
```


## Structure

```
.
├── build-dockerfile.sh
├── configs
│   ├── config_example.yaml
│   ├── icp_flow.yaml
│   └── ros2_humble.yaml
├── dockerfiles
│   └── icpflow
│       └── dockerfile
├── envs
│   ├── build-env.sh
│   └── dockerctl.yaml
├── README.md
└── run-docker.sh
```
- dockerfiles: Additional Docker files (not directly related to this repository)
- configs: Configuration files for the container
- envs: Environment scripts required to run this repository
