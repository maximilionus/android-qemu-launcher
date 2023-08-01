# Core components for global use within the scope of this project.


require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action reqires the root privileges"
        exit 1
    fi
}
