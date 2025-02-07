# allow for easy path appending, preventing duplicates
typeset -U path PATH
pathadd() {
    local p
    if [[ $# -lt 1 ]]; then
        if [[ -d "node_modules" ]]; then
            echo "Using local node_modules folder"
            p=$(readlink -f "node_modules/.bin")
        else
            echo "No arguments provided"
            return 1
        fi
    else
        p=$(readlink -f "$1")
    fi
    if [[ -d "$p" ]]; then
        path=("$p" $path)
    fi
}

