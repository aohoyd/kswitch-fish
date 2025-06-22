function ks -d "Switch Kubernetes contexts with optional namespace"
    # Parse arguments using argparse
    set -l context $argv[1]
    set -l namespace $argv[2]

    # Check for multiple positional arguments
    if test (count $argv) -gt 2
        echo "Error: too many arguments" >&2
        return 1
    end

    # Case 1: No arguments - interactive context selection
    if test -z "$argv[1]"
        __ks_interactive
        return $status
    end

    # Case 2: Context specified (with optional namespace)
    if test -n "$argv[1]"
        __ks_set_context "$argv[1]" "$argv[2]"
        return $status
    end
end

function __ks_set_context
    set -l context $argv[1]
    set -l namespace $argv[2]

    # Find which file contains this context
    set -l config_file (__ks_find_context_file "$context")

    if test -z "$config_file"
        echo "Error: Context '$context' not found in any kubeconfig file" >&2
        return 1
    end

    # Export KUBECONFIG and switch context
    set -gx KUBECONFIG "$config_file"
    kubectl config use-context "$context" >/dev/null 2>&1
    if test -n "$namespace"
        kubectl config set-context --current --namespace="$argv[2]" >/dev/null 2>&1
    else
        set namespace (kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        if test -z "$namespace"
            set namespace "default"
        end
    end

    echo "switched to \"$context\" context \"$namespace\" namespace"
end

function __ks_find_context_file
    set -l target_context $argv[1]

    for file_context in (__ks_get_contexts)
        set -l pair (string split -m1 ':' "$file_context")
        set -l file $pair[1]
        set -l context $pair[2]
        if test "$context" = "$target_context"
            echo "$file"
            return 0
        end
    end

    return 1
end

function __ks_interactive
    # Collect all contexts with their source files into single array
    set -l context_list (__ks_get_contexts)

    if test (count $context_list) -eq 0
        echo "No contexts found in kubeconfig files" >&2
        return 1
    end

    # Use fzf to select context
    set -l selection (printf '%s\n' $context_list | fzf --delimiter=':' --with-nth=2.. --prompt=" > " --preview 'bat --color=always --language=yaml {1}')

    if test -z "$selection"
        echo "No context selected"
        return 1
    end

    # Parse the selection to get file and context
    set -l selected_pair (string split -m1 ':' "$selection")
    set -l selected_file $selected_pair[1]
    set -l selected_context $selected_pair[2]

    set -gx KUBECONFIG "$selected_file"
    kubectl config use-context "$selected_context"
end
