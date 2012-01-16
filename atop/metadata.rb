# encoding: UTF-8
maintainer       "Tárhelypark"
maintainer_email "office@tarhelypark.hu"
license          "Apache 2.0"
description      "Installs atop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "build-essential"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "atop", "Installs atop"