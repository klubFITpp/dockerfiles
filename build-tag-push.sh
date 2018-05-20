#!/usr/bin/env bash

set -euo pipefail

export PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PROJECT_USERNAME_LOWER="$(echo ${CI_PROJECT_NAMESPACE} | tr '[:upper:]' '[:lower:]')"


function build-tag-push-single {
        set -x
        cd "${1}"
        FOLDER_LOWER="$(echo "${1}" | tr '[:upper:]' '[:lower:]')"

        IMAGE_NAME="${PROJECT_USERNAME_LOWER}"/"${FOLDER_LOWER}"
        
        docker build . -t "${IMAGE_NAME}":"${CI_COMMIT_SHA}"

        docker push "${IMAGE_NAME}":"${CI_COMMIT_SHA}"

        set +u

        if [ ! -z "$CIRCLE_PR_NUMBER" ]; then
            docker tag "${IMAGE_NAME}":"${CI_COMMIT_SHA}" "${IMAGE_NAME}":PR-"${CIRCLE_PR_NUMBER}"
            docker push  "${IMAGE_NAME}":PR-"${CIRCLE_PR_NUMBER}"
        fi

        if [ ! -z "$CI_COMMIT_REF_SLUG" ]; then
            docker tag "${IMAGE_NAME}":"${CI_COMMIT_SHA}" "${IMAGE_NAME}":"${CI_COMMIT_REF_SLUG}"
            docker push "${IMAGE_NAME}":"${CI_COMMIT_REF_SLUG}"
        fi
    
        if [ "${CI_COMMIT_REF_SLUG}" == "master" ]; then 
            docker tag "${IMAGE_NAME}":"${CI_COMMIT_SHA}" "${IMAGE_NAME}":latest 
            docker push "${IMAGE_NAME}":latest 
        fi
        set -u
}

mkdir -p ${PROJECT_ROOT}/.out

declare -A build_pids

for D in *; do
    cd "${PROJECT_ROOT}"
    if [ -d "${D}" ]; then
        build-tag-push-single "${D}" &> "${PROJECT_ROOT}/.out/${D}.txt" &
        build_pids["${D}"]=$!
    fi
done

tput_red=$(tput setaf 1)
tput_green=$(tput setaf 2)
tput_yellow=$(tput setaf 3)
tput_normal="\e[0m"

failed_pids=""

echo -e "Build succesfully:"

for image_name in "${!build_pids[@]}"; do
        if wait ${build_pids[$image_name]}; then
                echo -e "\t${tput_green}+ ${image_name}${tput_normal}"
        else
                failed_pids+="\t${tput_red}- ${image_name}${tput_normal}"
        fi
done

if [ ! -z "$failed_pids" ]; then
    echo -e "\nFailed:"
    echo -e ${failed_pids}
    echo -e "${tput_yellow}\nSee artifacts${tput_normal}\n"
    exit 1
fi