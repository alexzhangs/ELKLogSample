#!/bin/bash -e

[[ $DEBUG -gt 0 ]] && set -x || set +x

BASE_DIR="$(cd "$(dirname "$0")"; pwd)"


usage () {
    printf "create elasticsearch roles and users from pre-defined json files.\n\n"

    printf "${0##*/}\n"
    printf "\t-e ES_URL\n"
    printf "\t[-u USER]\n"
    printf "\t[-p PASS]\n"
    printf "\t[-h]\n\n"
    exit 255
}

generate_password () {
    echo "${1}passw0rd"
}

is_role_exist () {
    local http_code=$(curl -u ${USER}:${PASS} -s -w %{http_code} -o /dev/null $ES_URL/_xpack/security/role/"$1")
    test $http_code -eq 200
}

create_role () {
    local json=${1:?}
    local rolename=$(basename "${json%.json}")

    printf "$rolename: "
    if is_role_exist "$rolename"; then
        echo "already exists"
    else
        curl -XPOST -u "${USER}:${PASS}" --data-binary @"$json" -s -w %{http_code} -o /dev/null $ES_URL/_xpack/security/role/$rolename
        echo "created"
    fi
}

is_user_exist () {
    local http_code=$(curl -u ${USER}:${PASS} -s -w %{http_code} -o /dev/null $ES_URL/_xpack/security/user/"$1")
    test $http_code -eq 200
}

create_user () {
    local json=${1:?}
    local username=$(basename "${json%.json}")
    local password=$(generate_password "$username")

    printf "$username: "
    if is_user_exist "$username"; then
        echo "already exists"
    else
        curl -XPOST -u "${USER}:${PASS}" --data-binary "$(sed "s|<PASSWORD>|$password|" "$json")" -s -w %{http_code} -o /dev/null $ES_URL/_xpack/security/user/$username
        echo "created"
    fi
}

while getopts e:u:p:h opt; do
    case $opt in
        e)
            ES_URL=$OPTARG
            ;;
        u)
            USER=$OPTARG
            ;;
        p)
            PASS=$OPTARG
            ;;
        h)
            usage
            ;;
    esac
done

find $BASE_DIR/roles -type f -name '*.json' \
    | while read ln; do
        create_role "$ln"
    done

find $BASE_DIR/users -type f -name '*.json' \
    | while read ln; do
        create_user "$ln"
    done

exit
