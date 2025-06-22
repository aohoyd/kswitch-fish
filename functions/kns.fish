function kns -d "Switch Kubernetes namespaces in current context"
    # Parse arguments using argparse
    set -l namespace $argv[1]

    # Check for multiple positional arguments
    if test (count $argv) -gt 1
        echo "Error: too many arguments" >&2
        return 1
    end

    # Case 1: No arguments - interactive namespace selection
    if test -z "$argv[1]"
        __ks_namespace_interactive
        return $status
    end

    # Case 2: Set specific namespace
    if test -n "$argv[1]"
        __ks_set_namespace_current "$argv[1]"
        return $status
    end
end

function __ks_namespace_interactive
    # Collect all contexts with their source files into single array
    set -l ns_list (__ks_get_namespaces)

    if test (count $ns_list) -eq 0
        echo "No namespaces found" >&2
        return 1
    end

    # Use fzf to select ns
    set -l selection (printf '%s\n' $ns_list | fzf --prompt=" > ")

    if test -z "$selection"
        echo "No namespace selected"
        return 1
    end

    set -l selected_ns $selection
    __ks_set_namespace_current "$selected_ns"
end

function __ks_set_namespace_current
    kubectl config set-context --current --namespace="$argv[1]" 1>/dev/null
    or return 1
    echo "switched to \"$argv[1]\" namespace"
end
