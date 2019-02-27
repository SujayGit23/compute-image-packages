#!/bin/bash
# Copyright 2018 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


NAME="google-compute-engine-oslogin"
VERSION="1.5.0"

rpm_working_dir=/tmp/rpmpackage/${NAME}-${VERSION}
working_dir=${PWD}
if [[ $(basename "$working_dir") != $NAME ]]; then
  echo "Packaging scripts must be run from top of package dir."
  exit 1
fi

# Build dependencies.
sudo yum -y install make gcc-c++ libcurl-devel json-c json-c-devel pam-devel policycoreutils-python boost-devel

# RPM creation tools.
sudo yum -y install rpmdevtools

rm -rf /tmp/rpmpackage
mkdir -p ${rpm_working_dir}/{SOURCES,SPECS}
cp packaging/${NAME}.spec ${rpm_working_dir}/SPECS/

tar czvf ${rpm_working_dir}/SOURCES/${NAME}_${VERSION}.orig.tar.gz  --exclude .git --exclude packaging --transform "s/^\./${NAME}-${VERSION}/" .

rpmbuild --define "_topdir ${rpm_working_dir}/" --define "_version ${VERSION}" \
  -ba ${rpm_working_dir}/SPECS/${NAME}.spec
