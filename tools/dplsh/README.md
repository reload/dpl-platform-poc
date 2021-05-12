# KK Webplatform Operations Shell #

A small docker-based shell that eases the use of terraform and other ops tools.

`dplsh` clones `${HOME}/.azure` into the shell which makes your local azure CLI state available from the shell. It also source `.dplsh.profile` if the file exists in the directory which allows you to implement project-specific tweaks.

## Prerequisites
* Docker, [see section about authentication](../../sitefactory/README.md#authenticating-the-docker-cli)
* [jq](https://stedolan.github.io/jq/download/)
* Bash 4 or newer

## Installation
```shell
# Make sure the image is built:
task build

# OR pull the image from the registry (requires auth with a PAT, see Prerequisites):
docker pull docker.pkg.github.com/reload/dpl-platform-poc/dplsh:latest

# Optional, this step is assumed in the remaining examples though.
ln -s /path/to/checkout/tools/dplsh/dplsh.sh /usr/local/bin/dplsh
```

## Bootstrap without installation
```shell
# You could also launch dplsh like this (requires image to be built or pulled first)
bash -c "$(docker run docker.pkg.github.com/reload/dpl-platform-poc/dplsh:latest bootstrap)"
```

## Usage

### Example 1
```shell
$ touch /project/.dplsh.profile.my-profile
$ cd /project/some/subpath
$ dplsh -p my-profile
```
 dplsh will launch a container and do the following inside it
   * mount /project as /home/dplsh/host_mount
   * mount /project/.dplsh.profile.my-profile as  /home/dplsh/.dplsh.profile
   * cd to /home/dplsh/host_mount/some/subpath
   * source /home/dplsh/.dplsh.profile
Notice, CWD while sourcing is the subdirectory the shell was launched for in.

### Example 2
```shell
$ touch /project/.dplsh.profile
$ cd /project/some/random
$ dplsh
```
Same as example 1, but the shell will now default to .dplsh.profile

### Example 3:
```shell
$ touch /project/subdir/.dplsh.profile
$ cd /project/subdir
$ dplsh
```
Same as example 1, but the shell will now mount /project/subdir as /home/dplsh/host_mount thus "jailing" the shell inside the directory it was launched from.


## Docker and Kind
dplsh comes with Kubernetes IN Docker (kind) installed. Kind can be used to launch Kubernetes clusters for development, testing and CI.
As long as dplsh can mount the docker-socket, kind will be functional. To launch a cluster and connect to it do the following.

Creating a cluster or connecting to an existing via a profile
```shell
# Start a dplsh instance with a kind cluster. If one already exist you will be connected to it right away, if not one will be created
$ dplsh -p kind

# See if we have a connection
$ kubectl get nodes
```

Manually creating a cluster via dplsh
```shell
# Inside dplsh
$ kind create cluster
# Cluster is created, if you get a permission denied, see the troubleshooting section.
$ kind get clusters
# Should list the "kind" cluster

# Connect to the kind network and get a kubeconfig
$ kind-connect

# See if we have a connection
$ kubectl get nodes
```


Connecting to an existing kind cluster from dplsh
```shell
# Inside dplsh
# Connect to the kind network and get a kubeconfig
$ kind-connect clustername

# See if we have a connection
$ kubectl get nodes
```


## Connecting to AKS
The `az` cli tool cannot be authorized for non KK-enrolled machines, and getting access to a AKS cluster inside a KK subscription is a bit tricky as getting the credentials for the cluster requires the invocation of a `az` command.
A workaround is to use the Azure cloud shell from a browser, doing a `az aks get-credential`, and extracting `~/.kube/config`.

dplsh can make it a bit easier to use an extracted kube-config without having to merge it into a local kube-config.

```shell
# Retrieve the kube-config and place it in <checkout-root>/aks.kubeconfig

# Then launch dplsh with the kubeconfig profile
dplsh -p aks-connect
```

# Troubleshooting

## Unable to connect to docker due to "Permission denied"

dplsh will attempt to mount the `/var/run/docker.sock` into its container in order to make Docker available. On the initial mount the socket will not be writable by the dplsh user, and you may see an error like `Got permission denied while trying to connect to the Docker daemon socket`.

This can be fixed by starting dplsh as root, and changing the permissions of the socket from inside the container. On Docker for Mac, this change will persist until the next reboot of the host, and will only be persisted inside containers.
On Linux, however, this change persists on the host, and means that docker.sock is no longer owned by root.

dplsh can perform the update automatically by being launched with
```shell
dplsh --fix-docker
````
