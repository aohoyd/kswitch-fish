# Fish completions for ks and kns

# Helper function to get all available contexts
function __ks_complete_contexts
    if type -q __ks_get_contexts
        __ks_get_contexts 2>/dev/null | string replace -r '^[^:]*:' ''
    end
end

# Helper function to get all available namespaces
function __ks_complete_namespaces
    if type -q __ks_get_namespaces
        __ks_get_namespaces 2>/dev/null
    end
end

function __ks_complete
    # Completions for ks (context switching)
    complete -c ks -f -n '__fish_is_first_token' -a '(__ks_complete_contexts)' -d 'Kubernetes context'
    complete -c ks -f -n 'test (count (commandline -opc)) -eq 2' -a '(__ks_complete_namespaces)' -d 'Kubernetes namespace'

    # Completions for kns (namespace switching)
    complete -c kns -f -n '__fish_is_first_token' -a '(__ks_complete_namespaces)' -d 'Kubernetes namespace'

    # Prevent further completions after second argument for ks
    complete -c ks -f -n 'test (count (commandline -opc)) -gt 3'

    # Prevent further completions after first argument for kns
    complete -c kns -f -n 'test (count (commandline -opc)) -gt 2'
end
