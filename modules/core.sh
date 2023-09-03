# Core components for global use within the scope of this project.

# Require root (sudo) access and exit if script executed not by root.
require_root () {
    if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "This action reqires the root privileges"
        exit 1
    fi
}

# Execute the command with set number of retries and exit on fail.
#
# Args:
# $1: Command to execute.
# $2: Echo message tesxt on success. (Default: "[ Success ]")
# $3: Echo message text after $5 failed tries. (Default: "[ Failed. Shutting down ]")
# $4: Delay between retries in seconds. (Default: 3)
# $5: Maximum retries before fail. (Default: 3)
exec_with_retry () {
    command=$1
    msg_success=${2:-"[ Success ]"}
    msg_failed=${3:-"[ Failed. Shutting down ]"}
    retry_delay=${4:-3}
    max_tries=${5:-3}

    tries=1
    until eval $command; do
        if ((tries >= max_tries)); then
            echo $msg_failed
            exit 1
        fi

        ((tries++))

        echo "Retrying in $retry_delay sec. Attempt: $tries of $max_tries"
        sleep $retry_delay
    done

    echo $msg_success
}
