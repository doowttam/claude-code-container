# Claude Code Container

A container and supporting scripts to reasonably sandbox Claude Code
 - Includes a restrictive firewall that limits outward connections
 - Based on Anthropic's original reference container, but with changes motivated by daily use

## Overview

Build the container from the repo directory:

```
$> ./build_podman.sh
```

Run from your project directory:

```
$> <path to repo>/run_claude_here_podman.sh
```

This will start Claude with your current directory mounted at `/workspace` in the container.

## Project Scripts

**Podman Only**

For particular projects you may need additional resources installed in your container. This might include libraries that need to be built within the container, or extra context like documentation.

Put a `Dockerfile.claude` (like `Dockerfile.claude.example`) in your project directory and use the project scripts to build/run a container with those additions. 

Build the container from your project directory:

```
$> <path to repo>/build_project_claude_here.sh
```

Run from your project directory:

```
$> <path to repo>/run_project_claude_here.sh
```

## Components

- Build scripts
    - `build_docker.sh`: Build with docker
    - `build_podman.sh`: Build with podman
- Run scripts
    - `run_claude_here_docker.sh`: Mount the current directory as your project and run with docker
    - `run_claude_here_podman.sh`: Mount the current directory as your project and run with podman
- Project scripts
    - `build_project_claude_here.sh`: Build `Dockerfile.claude` on top of the main image, tied to this directory, with podman
    - `run_project_claude_here.sh`: Run the container tied to this directory with podman
- `Dockerfile`: Main sandbox container file
- `entrypoint.sh`: Updates the UID/GID of the node user to match the host user and sets up the firewall
- `init-firewall.sh`: Sets up the firewall with iptables

## Security

Motivated agents have proven to be escape artists. This sandbox is geared towards stopping coding agents before they go off on weird tangents and keeping them from trouncing your machine.

**Do not rely on this to protect against malicious agents.** For one: the firewall rules live inside the container for convenience. If you're running potentially malicious software, definitely use the firewall on your host.

## Why Docker and Podman scripts?

I'm in the process of moving to rootless podman for all of my sandbox containers. This repo is in transition.

