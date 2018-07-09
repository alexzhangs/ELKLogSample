#!/bin/bash -e

[[ $DEBUG -gt 0 ]] && set -x || set +x

BASE_DIR="$(cd "$(dirname "$0")"; pwd)"

function usage () {
    printf "Install ELK Log Sample configuration and tools.\n\n"

    printf "${0##*/}\n"
    printf "\t[-r]\n"
    printf "\t[-f]\n"
    printf "\t[-e]\n"
    printf "\t[-l]\n"
    printf "\t[-k]\n"
    printf "\t[-h]\n"

    printf "OPTIONS\n"
    printf "\t[-r]\n\n"
    printf "\tInstall configuration of logrotate.\n\n"

    printf "\t[-f]\n\n"
    printf "\tInstall configuration of Filebeat.\n"
    printf "\tAny existing *.yml files under /etc/filebeat will be deleted first.\n\n"

    printf "\t[-e]\n\n"
    printf "\tTODO: Install configuration of Elasticsearch.\n\n"

    printf "\t[-l]\n\n"
    printf "\tInstall configuration of Logstash.\n\n"

    printf "\t[-k]\n\n"
    printf "\tTODO: Install configuration of Kibana.\n\n"

    printf "\t[-h]\n\n"
    printf "\tThis help.\n\n"
    exit 255
}

function install_logrotate_conf () {
    /bin/mkdir -pv "$log_dir"
    /bin/cp -av "$BASE_DIR"/logrotated/elklogsample /etc/logrotate.d
}

function install_filebeat_conf () {
    /bin/rm -fv /etc/filebeat/*.yml
    /bin/cp -av "$BASE_DIR"/filebeat/*.yml /etc/filebeat
}

function install_es_conf () {
    : # TODO
}

function install_logstash_conf () {
    /bin/cp -av "$BASE_DIR"/logstash/conf.d/*.conf /etc/logstash/conf.d
}

function install_kibana_conf () {
    : # TODO
}


[[ $# -eq 0 ]] && usage

logrotate=0
filebeat=0
es=0
logstash=0
kibana=0
while getopts r:felkh opt; do
    case $opt in
        r)
            logrotate=1
            log_dir=$OPTARG
            ;;
        f)
            filebeat=1
            ;;
        e)
            es=1
            ;;
        l)
            logstash=1
            ;;
        k)
            kibana=1
            ;;
        h|*)
            usage
            ;;
    esac
done

if [[ $logrotate -eq 1 ]]; then
    install_logrotate_conf
fi

if [[ $filebeat -eq 1 ]]; then
    install_filebeat_conf
fi

if [[ $es -eq 1 ]]; then
    install_es_conf
fi

if [[ $logstash -eq 1 ]]; then
    install_logstash_conf
fi

if [[ $kibana -eq 1 ]]; then
    install_logstash_conf
fi

exit
