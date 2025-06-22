function __ks_get_contexts
    set -l files

    # Add default config if it exists
    if test -f ~/.kube/config
        set -a files ~/.kube/config
    end

    set -a files (fd --search-path ~/.kube/configs/ -t file --absolute-path)

    yq ea '[{"file": filename, "contexts": .contexts}][]
        | .contexts |= (
            with(select(type == "!!seq"); . = [.[].name])
            | with(select(type == "!!map"); . = keys))
        | select(.contexts | length != 0)
        | .file + ":" + .contexts[]
    ' $files
end
