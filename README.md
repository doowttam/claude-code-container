# Claude Code Container

Anthropic provides a reference container, described [here](https://docs.anthropic.com/en/docs/claude-code/security#development-container-reference-implementation), to restrict file and network access for Claude Code.

I think this is a Very Good Idea. However, their container is designed for VS Code. This does the same thing, but is designed to be used in a terminal on its own. Perfect for use in tmux alongside your favorite editor.

1. Build the Docker image: `./build.sh`
2. Change to the directory you want Claude Code to have access to and run: `/path/to/run_claude_here.sh`

If you want to change the command, for example to resume, pass the command as an argument: `/path/to/run_claude_here.sh claude --resume`

## The Reference

The reference is designed to be used with VS Code and consists of:

- [devcontainer.json](https://github.com/anthropics/claude-code/blob/main/.devcontainer/devcontainer.json): Controls container settings, extensions, and volume mounts
- [Dockerfile](https://github.com/anthropics/claude-code/blob/main/.devcontainer/Dockerfile): Defines the container image and installed tools
- [init-firewall.sh](https://github.com/anthropics/claude-code/blob/main/.devcontainer/init-firewall.sh): Establishes network security rules

## This Implementation

This implementation is based on that reference, but designed to be used outside of VS Code.

The components are:

- build.sh: A single docker build command
- Dockerfile: Defines the container and installs the tools used in the reference
- entrypoint.sh: Updates the UID/GID of the node use to match the host user and sets up the firewall
- init-firewall.sh: The same firewall script from the reference
- run_claude_here.sh: Runs the `docker run` with all the required flags and mounts the current working directory as the workspace used by claude code

