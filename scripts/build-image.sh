#!/bin/bash

set -e

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h  --help      帮助"
    echo "  -m= --module=   模块名称"
    echo "  -i= --image=    镜像名称"
    echo "  -t= --tag=      镜像标签"
    exit
}

MODULE=nats-sub
REGISTORY=xflying
IMAGE=nats-sub
TAG=dev
WITHBUILD=${WITHBUILD:-0}

for i in "$@"
do
case $i in
    -h|--help)
    usage
    exit 0
    ;;
    -m=*|--module=*)
    MODULE=${i#*=}
    shift
    ;;
    -i=*|-image=*)
    IMAGE=${i#*=}
    shift
    ;;
    -t=*|--tag=*)
    TAG=${i#*=}
    shift
    ;;
    *)
    echo "unknown options"
    exit 1
    ;;
esac
done

IMAGE_NAME="$REGISTORY/$IMAGE:$TAG"

# get script base dir
pushd . > /dev/null
CWD="${BASH_SOURCE[0]}";
while([ -L "${CWD}" ]); do
    cd "`dirname "${CWD}"`"
    CWD="$(readlink "$(basename "${CWD}")")";
done
BUILD_HOME="$(dirname "${CWD}")"
BASEDIR="$(PWD)"
PROJ_NAME="github.com/flyingfang/keda-nats-demo"
OUTPUT_DIR="_output"

if [[ "x$WITHBUILD" == "x1" ]]; then
  docker run -v $BASEDIR:/go/src/$PROJ_NAME  --rm golang:1.13.5 \
  bash -c "mkdir -p /go/src/$PROJ_NAME/$OUTPUT_DIR \\
  && go env -w GOPROXY=goproxy.cn \\
  && cd /go/src/$PROJ_NAME/$MODULE \\
  && go build -o /go/src/$PROJ_NAME/$OUTPUT_DIR/$MODULE -v ."
fi

cp "$BASEDIR/$OUTPUT_DIR/$MODULE" "$BASEDIR/$MODULE/docker"
docker build -t $IMAGE_NAME "$BASEDIR/$MODULE/docker"

echo "Use docker push $IMAGE_NAME to publish image"