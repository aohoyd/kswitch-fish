function ksi -d "Display current Kubernetes context and namespace info"
    echo "Current KUBECONFIG: $KUBECONFIG"
    if test -n "$KUBECONFIG" -a -f "$KUBECONFIG"
        echo "Current context: $(kubectl config current-context 2>/dev/null || echo 'none')"
        set -l current_ns (kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        if test -n "$current_ns"
            echo "Current namespace: $current_ns"
        else
            echo "Current namespace: default"
        end
    else
        echo "No valid KUBECONFIG set"
    end
end
