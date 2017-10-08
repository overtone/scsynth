require "fileutils"

JDK8 = [
  "linux-arm32-vfp-hflt",
  "linux-arm64-vfp-hflt",
  "linux-i586",
  "linux-x64",
  "macosx-x64",
  "windows-i586",
  "windows-x64"
]

JDK_ARCH = ["arm32-vfp-hflt", "arm64-vfp-hflt", "i586", "x64"]
JDK_OS = ["linux", "macosx", "windows"]

SC_AUDIOAPI = ["portaudio", "jack1", "jack2", "coreaudio"]

DOCKER_UBUNTU_VERSIONS = [
  "precise",
  "trusty",
  "xenial",
  "yakkety",
  "zesty"
]

DOCKER_FEDORA_VERSIONS = [
  "25",
  "24",
  "23",
  "22",
  "21"
]

SUPERCOLLIDER_GIT_TAGS = [
  "Version-3.5",
  "Version-3.5.1",
  "Version-3.5.2",
  "Version-3.5.3",
  "Version-3.5.4",
  "Version-3.5.5",
  "Version-3.5.6",
  "Version-3.5.7",
  "Version-3.5.7",
  "Version-3.6.0",
  "Version-3.6.1",
  "Version-3.6.2",
  "Version-3.6.3",
  "Version-3.6.4",
  "Version-3.6.5",
  "Version-3.6.6",
  "Version-3.7.0",
  "Version-3.7.1",
  "Version-3.7.2",
  "Version-3.8.0",
]

UBUNTU_DEPS_COMMON = [
  "build-essential",
  "libsndfile1-dev",
  "libfftw3-dev",
  "libxt-dev",
  "libudev-dev",
  "pkg-config",
  "cmake"
]

buildfile_code = <<-END_CODE
#!/bin/bash
set -e

END_CODE


DOCKER_UBUNTU_VERSIONS.each do |u|
  d = "scsynth-ubuntu-#{u}-x86-64"
  FileUtils.mkdir_p d
  code = <<-END_CODE
FROM ubuntu:#{u}
  END_CODE
  File.write("#{d}/Dockerfile", code)
  buildfile_code += "docker build -t #{d} #{d}\n"
end

DOCKER_FEDORA_VERSIONS.each do |u|
  d = "scsynth-fedora-#{u}-x86-64"
  FileUtils.mkdir_p d
  code = <<-END_CODE
FROM fedora:#{u}
  END_CODE
  File.write("#{d}/Dockerfile", code)
  buildfile_code += "docker build -t #{d} #{d}\n"
end

File.write("build.sh", buildfile_code)

