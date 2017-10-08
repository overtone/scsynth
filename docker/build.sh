#!/bin/bash
set -e

docker build -t scsynth-ubuntu-precise-x86-64 scsynth-ubuntu-precise-x86-64
docker build -t scsynth-ubuntu-trusty-x86-64 scsynth-ubuntu-trusty-x86-64
docker build -t scsynth-ubuntu-xenial-x86-64 scsynth-ubuntu-xenial-x86-64
docker build -t scsynth-ubuntu-yakkety-x86-64 scsynth-ubuntu-yakkety-x86-64
docker build -t scsynth-ubuntu-zesty-x86-64 scsynth-ubuntu-zesty-x86-64
docker build -t scsynth-fedora-25-x86-64 scsynth-fedora-25-x86-64
docker build -t scsynth-fedora-24-x86-64 scsynth-fedora-24-x86-64
docker build -t scsynth-fedora-23-x86-64 scsynth-fedora-23-x86-64
docker build -t scsynth-fedora-22-x86-64 scsynth-fedora-22-x86-64
docker build -t scsynth-fedora-21-x86-64 scsynth-fedora-21-x86-64
