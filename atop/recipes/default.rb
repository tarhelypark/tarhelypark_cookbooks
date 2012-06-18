main_version = node[:atop][:main_version]
minor_version = node[:atop][:minor_version]
if node[:kernel][:machine] =~ /x86_64/
  arch = node[:kernel][:machine]
else
  arch = "i586"
end
source_link = node[:atop][:link] + "#{main_version}.tar.gz"
rpm_link = node[:atop][:link] + "#{main_version}-#{minor_version}.#{arch}.rpm"

case node[:platform] 
when "ubuntu","debian"  
  package "libncurses5-dev"
  package "libncursesw5-dev"

  # download source file to /tmp
  remote_file "/tmp/atop.tar.gz" do
    source source_link
    not_if { File.exists?("/tmp/atop.tar.gz")}
  end

  execute "unpack atop" do
    cwd "/tmp"
    command "tar xvzf /tmp/atop.tar.gz"
    only_if { File.exists?("/tmp/atop.tar.gz")}
  end

  execute "make and install atop" do
    cwd "/tmp/atop-#{main_version}"    
    command "make && make install"
  end
when "redhat","centos","fedora"
  package "ncurses-devel"
  package "ncurses"

  # download rpm to /tmp
  remote_file "/tmp/atop.rpm" do
    source rpm_link
    not_if { File.exists?("/tmp/atop.rpm")}
  end

  package "atop" do
    action :install
    source "/tmp/atop.rpm"
    provider Chef::Provider::Package::Rpm
     not_if { File.exists?("/usr/bin/atop")}
  end    
end