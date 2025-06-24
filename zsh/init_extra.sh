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

pathadd ~/.local/bin

# fix PDF files for using with stupid outdated printing devices
pfix() {
    if [[ $# -lt 1 ]]; then
        echo "No arguments provided"
        exit 1
    fi
    mkdir -p pfix
    for f in "${@}"; do
        filename=${f%.*}
        pdf2ps $f ${filename}.ps
        ps2pdf12 ${filename}.ps pfix/${filename}.pdf
        rm ${filename}.ps
    done
}

# Fedora rpm-ostree alias with 'status' as default
rost() {
    rpm-ostree ${@:-status}
}
