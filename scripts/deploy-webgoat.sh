#!/usr/bin/env bash

echo "GSS Inside script deploy-webgoat.sh"

export DOCKER_USER=gssachdeva
export DOCKER_PASS=Sept\$0409

echo "GSS DOCKER_USER = $DOCKER_USER"
echo "GSS DOCKER_PASS = $DOCKER_PASS"

docker login -u $DOCKER_USER -p $DOCKER_PASS
#export REPO=webgoat/webgoat-8.0
export REPO=gssachdeva/webgoat

cd webgoat-server
ls target/

if [ ! -z "${TRAVIS_TAG}" ]; then
  echo "GSS Trying to push to Docker hub"
  # If we push a tag to master this will update the LATEST Docker image and tag with the version number
  docker build --build-arg webgoat_version=${TRAVIS_TAG:1} -f Dockerfile -t $REPO:latest -t $REPO:${TRAVIS_TAG} .
  echo "GSS TRAVIS TAG = $TRAVIS_TAG"
  echo "GSS REPO = $REPO"
  docker push $REPO
  echo "GSS After docker push"
#elif [ ! -z "${TRAVIS_TAG}" ]; then
#  # Creating a tag build we push it to Docker with that tag
#  docker build --build-arg webgoat_version=${TRAVIS_TAG:1} -f Dockerfile -t $REPO:${TRAVIS_TAG} -t $REPO:latest .
#  docker push $REPO
#elif [ "${BRANCH}" == "develop" ]; then
#  docker build -f Dockerfile -t $REPO:snapshot .
#  docker push $REPO
else
  echo "Skipping releasing to DockerHub because it is a build of branch ${BRANCH}"
fi


export REPO=webgoat/webwolf
cd ..
cd webwolf
ls target/

if [ ! -z "${TRAVIS_TAG}" ]; then
  # If we push a tag to master this will update the LATEST Docker image and tag with the version number
  docker build --build-arg webwolf_version=${TRAVIS_TAG:1} -f Dockerfile -t $REPO:latest -t $REPO:${TRAVIS_TAG} .
  docker push $REPO
else
  echo "Skipping releasing to DockerHub because it is a build of branch ${BRANCH}"
fi
