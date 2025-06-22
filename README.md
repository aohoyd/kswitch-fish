# kswitch

A fast and intuitive Kubernetes context and namespace switcher for Fish shell.

## Features

- 🚀 **Fast context switching** with interactive selection using fzf
- 🎯 **Namespace management** with fuzzy search
- 📁 **Multiple kubeconfig support** - automatically discovers configs in `~/.kube/config` and `~/.kube/configs/`
- 🔍 **Context info display** - shows current context, namespace, and kubeconfig path
- ⚡ **Tab completion** for contexts and namespaces
- 🎨 **Syntax highlighting** in fzf previews using bat

## Installation

Install using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install aohoyd/kswitch
```

## Prerequisites

This plugin requires the following tools to be installed:

- [`kubectl`](https://kubernetes.io/docs/tasks/tools/#kubectl) - Kubernetes command-line tool
- [`fzf`](https://github.com/junegunn/fzf) - Fuzzy finder for interactive selection
- [`yq`](https://github.com/mikefarah/yq) - YAML processor for parsing kubeconfig files
- [`fd`](https://github.com/sharkdp/fd) - Fast file finder for discovering kubeconfig files
- [`bat`](https://github.com/sharkdp/bat) - Syntax highlighter for fzf previews (optional but recommended)

## Commands

### `ks` - Context Switcher

Switch between Kubernetes contexts with optional namespace specification.

#### Usage

```fish
# Interactive context selection with fzf
ks

# Switch to specific context
ks my-context

# Switch to context and set namespace
ks my-context my-namespace
```

#### Examples

```fish
# Launch interactive context selector
ks

# Switch to production context
ks prod-cluster

# Switch to staging context and set namespace to monitoring
ks staging-cluster monitoring
```

### `kns` - Namespace Switcher

Switch namespaces within the current context.

#### Usage

```fish
# Interactive namespace selection with fzf
kns

# Switch to specific namespace
kns my-namespace
```

#### Examples

```fish
# Launch interactive namespace selector
kns

# Switch to kube-system namespace
kns kube-system

# Switch to default namespace
kns default
```

### `ksi` - Context Info

Display current Kubernetes context information.

#### Usage

```fish
ksi
```

#### Example Output

```
Current KUBECONFIG: /home/user/.kube/configs/prod-cluster.yaml
Current context: prod-cluster
Current namespace: monitoring
```

## Configuration

### Kubeconfig File Discovery

The plugin automatically discovers kubeconfig files from:

1. `~/.kube/config` (default kubectl config)
2. All files in `~/.kube/configs/` directory

### Directory Structure Example

```
~/.kube/
├── config                    # Default kubectl config
└── configs/
    ├── prod-cluster.yaml
    ├── staging-cluster.yaml
    └── dev-cluster.yaml
```

## Tab Completion

The plugin provides intelligent tab completion:

- **`ks`**: Completes with available contexts, then namespaces
- **`kns`**: Completes with available namespaces

## Interactive Mode

Both `ks` and `kns` support interactive mode when called without arguments:

- **Context selection**: Shows all available contexts from all kubeconfig files with file preview
- **Namespace selection**: Shows all namespaces in the current context
- Use arrow keys or type to filter results
- Press Enter to select, Escape to cancel

## Environment Variables

The plugin sets the following environment variable:

- `KUBECONFIG`: Points to the currently active kubeconfig file

## Troubleshooting

### No contexts found

If you see "No contexts found in kubeconfig files":

1. Ensure you have kubeconfig files in `~/.kube/config` or `~/.kube/configs/`
2. Verify your kubeconfig files are valid YAML
3. Check that contexts are properly defined in your kubeconfig files

### Command not found errors

Ensure all prerequisites are installed:

```fish
# Check if required tools are available
which kubectl fzf yq fd bat
```

### Permission errors

Ensure your kubeconfig files have proper read permissions:

```fish
chmod 600 ~/.kube/config ~/.kube/configs/*
```
