function __ks_get_namespaces
    kubectl get namespaces -o name 2>/dev/null | string replace 'namespace/' ''
end
