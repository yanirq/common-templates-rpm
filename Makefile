REPO_ORG        := kubevirt
REPO_NAME       := common-templates

COMMIT          := $(shell git ls-remote https://github.com/${REPO_ORG}/${REPO_NAME}.git ${RELEASE} | tail -1 | awk '{ print $$1}' | tr -d [:blank:])
BUILDHASH        = $(shell echo ${COMMIT} | cut -c -7)
VERSION         := $(shell git ls-remote https://github.com/${REPO_ORG}/${REPO_NAME}.git | tail -1 | tr -d '^{}' | awk '{ print $2}' | cut -f 3 -d / | cut -f 2 -d v)
RPM_VERSION     := $(shell echo ${VERSION} | cut -f 1 -d -)
SPEC_RELEASE    := 1

## Capture manual edits by gathering variables from kubevirt-common-templates.spec ##
SPEC_FILE_RELEASE      = $(shell spectool -S kubevirt-common-templates.spec | awk '{ print $2 }' | cut -f '3' -d '-' | cut -f '1' -d '.')
SPEC_FILE_BUILDHASH    = $(shell spectool -S kubevirt-common-templates.spec | awk '{ print $2 }' | cut -f '3' -d '-' | cut -f '2' -d '.')
SPEC_FILE_VERSION      = $(shell spectool -S kubevirt-common-templates.spec | awk '{ print $2 }' | cut -f '2' -d '-')


release: spec tarball
	rhpkg new-sources ${REPO_NAME}-${RPM_VERSION}-${SPEC_RELEASE}.${BUILDHASH}.tar.gz

spec:
	sed -i 's/%global commit.*/%global commit ${COMMIT}/' kubevirt-common-templates.spec
	sed -i 's/Version:        .*/Version:        ${RPM_VERSION}/' kubevirt-common-templates.spec
	sed -i 's/%global spec_release.*/%global spec_release ${SPEC_RELEASE}/' kubevirt-common-templates.spec

tarball:
	wget -O common-templates-${SPEC_FILE_VERSION}-${SPEC_FILE_RELEASE}.${SPEC_FILE_BUILDHASH}.tar.gz https://github.com/${REPO_ORG}/${REPO_NAME}/archive/${COMMIT}/${REPO_NAME}-${SPEC_FILE_BUILDHASH}.tar.gz


.PHONY: release spec tarball
