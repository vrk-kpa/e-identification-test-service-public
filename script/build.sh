#!/bin/bash
set -e
PROJECTNAME=test-service
PWD=$(pwd)

unamestr=$(uname)
SCRIPTFILE="undefined"

# check os, os x users install coreutils: brew install coreutils
if [ $unamestr == "Linux" ]; then
  SCRIPTFILE=$(readlink -f "$0")
elif [ $unamestr == "Darwin" ]; then
  SCRIPTFILE=$(greadlink -f "$0")
fi

SCRIPTPATH=$(dirname "$SCRIPTFILE")

skip_depcheck="false"

cd ${SCRIPTPATH}/..
function usage
{
        echo "usage: $0 [OPTION] TARGET_ENV"
        echo
        echo "Builds a docker image"
        echo
        echo "  -p, --push                              Push to docker registry"
        echo
        echo "  -d, --no-deps                           Don't build dependency list"
        echo
        echo "  -ug , --ui-git                          Pull ui from git"
        echo "  -o, --skip-owasp-dep-check              Skip OWASP Maven dependency check plugin"
}

while [ "$1" != "" ]; do
    case $1 in
        "local" ) TARGET_ENV=local
                                ;;
        "dev" ) TARGET_ENV=dev
                                ;;
        "kete" ) TARGET_ENV=kete
                                ;;
        "test" ) TARGET_ENV=test
                                ;;
        "prod" ) TARGET_ENV=prod
                                ;;
        -ug | --ui-git )        uigit=1
                                ;;
        -t | --tag )        	IMAGE_TAG="$2"
                                shift
                                ;;
        -p | --push )           push=1
                                ;;
        -d | --no-deps )        nodeps=1
                                ;;
        -o | --skip-owasp-dep-check )
                                skip_depcheck="true"
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                echo $1
                                exit 1
    esac
    shift
done

MAVEN_DEPCHECK_PARAMS="-Ddependency-check.skip=${skip_depcheck}"
#build
if [ "$nodeps" = "1" ]; then
        mvn clean install ${MAVEN_DEPCHECK_PARAMS}
        mkdir -p target/site
else
        mvn clean install project-info-reports:dependencies -Ddependency.locations.enabled=false ${MAVEN_DEPCHECK_PARAMS}
fi

cd ${SCRIPTPATH}/..

# Pull the base image
docker pull e-identification-docker-virtual.vrk-artifactory-01.eden.csc.fi/e-identification-tomcat-apache2-shibd-sp-base-image
IMAGE_NAME=e-identification-docker-virtual.vrk-artifactory-01.eden.csc.fi/e-identification-test-service:${TARGET_ENV}

#build, tag and push docker image

docker build -f Dockerfile -t ${IMAGE_NAME} .
# Add labels to image, jenkins build tag, git commit, git branch, package list and jar list currently
DPKG_RESULT=$(docker run --rm --entrypoint="/usr/bin/dpkg-query" ${IMAGE_NAME} -W|sed -e 's/$/|/' -e 's/$/\\/')
JAR_LIST=$(mvn dependency:list -DoutputAbsoluteArtifactFilename=true|grep jar|sed -e 's/.* //' -e 's/.*://'|xargs md5sum|sed -e 's/ .*\// /' -e 's/$/|/' -e 's/$/\\/')
printf "FROM ${IMAGE_NAME}\nLABEL build-tag=${BUILD_TAG}\nLABEL git-commit=${GIT_COMMIT}\nLABEL git-branch=${GIT_BRANCH}\nLABEL dpkg-list=\"${DPKG_RESULT}\"\nLABEL jar-list=\"${JAR_LIST}\"\n"|docker build -t ${IMAGE_NAME} -

if [ "$push" = "1" ]; then
        docker push ${IMAGE_NAME}
fi

if [ ! -z ${IMAGE_TAG+x} ]; then
        docker tag ${IMAGE_NAME} ${IMAGE_NAME}_${IMAGE_TAG}
        if [ "$push" = "1" ]; then
                docker push ${IMAGE_NAME}_${IMAGE_TAG}
                docker rmi ${IMAGE_NAME}_${IMAGE_TAG}
        fi
fi
if [ "$push" = "1" ]; then
        docker rmi ${IMAGE_NAME}
fi

cd ${PWD}
