REPO_ORG        := kubevirt
REPO_NAME       := common-templates

COMMIT          := $(shell git ls-remote https://github.com/${REPO_ORG}/${REPO_NAME}.git ${RELEASE} | tail -1 | awk '{ print $$1}' | tr -d [:blank:])
BUILDHASH        = $(shell echo ${COMMIT} | cut -c -7)
VERSION         := $(shell git ls-remote https://github.com/${REPO_ORG}/${REPO_NAME}.git | tail -1 | tr -d '^{}' | awk '{ print $2}' | cut -f 3 -d / | cut -f 2 -d v)
RPM_VERSION     := $(shell echo ${VERSION} | cut -f 1 -d -)
SPEC_RELEASE    := 1

## Capture manual edits by gathering variables from common-templates.spec ##
SPEC_FILE_RELEASE      = $(shell spectool -S common-templates.spec | awk '{ print $2 }' | cut -f '4' -d '-' | cut -f '1' -d '.')
SPEC_FILE_BUILDHASH    = $(shell spectool -S common-templates.spec | awk '{ print $2 }' | cut -f '4' -d '-' | cut -f '2' -d '.')
SPEC_FILE_VERSION      = $(shell spectool -S common-templates.spec | awk '{ print $2 }' | cut -f '3' -d '-')

#spec
release: tarball
	rhpkg new-sources ${REPO_NAME}-${RPM_VERSION}-${SPEC_RELEASE}.${BUILDHASH}.tar.gz
spec:
	sed -i 's/%global commit.*/%global commit ${COMMIT}/' common-templates.spec
	sed -i 's/Version:        .*/Version:        ${RPM_VERSION}/' common-templates.spec
	sed -i 's/%global spec_release.*/%global spec_release ${SPEC_RELEASE}/' common-templates.spec

tarball:
	wget https://github.com/${REPO_ORG}/${REPO_NAME}/releases/download/v${RPM_VERSION}/common-templates.yaml
	tar -cvzf ${REPO_NAME}-${RPM_VERSION}-${SPEC_RELEASE}.${BUILDHASH}.tar.gz common-templates.spec common-templates.yaml

.PHONY: release spec tarball
