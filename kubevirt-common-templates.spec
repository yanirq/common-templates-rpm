#debuginfo not supported with Go
%global debug_package %{nil}

%global source_name v%{version}

%global commit ??? 
%global build_hash %(c=%{commit}; echo ${c:0:7})
%global spec_release 1

Name:		kubevirt-common-templates
Version:	???
Release:	%{spec_release}.%{build_hash}
Summary:	%{name} - Common Templates
		
License:	ASL 2.0
URL:		https://github.com/kubevirt/common-templates
Source0:	common-templates-%{version}-%{release}.tar.gz
BuildRequires:	golang

%description
CNV distribution based of kubevirt's Common Templates

Source Release https://api.github.com/repos/kubevirt/common-templates/tarball/%{build_hash}

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
%make_install


%files
%doc



%changelog

