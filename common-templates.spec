#debuginfo not supported with Go
%global debug_package %{nil}
%global source_name v%{version}

%global commit 2a5036a8551e54f0c9d418762eca7c36a6385cd0
%global build_hash %(c=%{commit}; echo ${c:0:7})
%global spec_release 1

Name:		common-templates
Version:	0.2.0
Release:	%{spec_release}.%{build_hash}
Summary:	%{name} - Common Templates
		
License:	ASL 2.0
URL:		https://github.com/kubevirt/common-templates
Source0:	common-templates-%{version}-%{release}.tar.gz

%description
CNV distribution based of kubevirt's Common Templates

%package	manifests
Summary:        %{package_name} - manifests
BuildArch: noarch
%description manifests
CNV kubevirt common templates - manifests

%prep

%build

%install
install -d -m 0755 %{buildroot}%{_datadir}/%{name}/manifests
cp -v common-templates.yaml %{buildroot}%{_datadir}/%{name}/manifests/ 

%files manifests
%{_datadir}/%{name}/manifests/


%changelog
* Sun Oct 14 2018 Yanir Quinn <yquinn@redhat.com> - 0.2.0-1.2a5036a
- kubevirt common templates rpm testing


