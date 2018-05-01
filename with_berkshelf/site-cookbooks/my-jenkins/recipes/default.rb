package 'java-1.8.0-openjdk' do
  action :install
end

include_recipe "jenkins::master"

check_site_xml = File.join(Chef::Config[:file_cache_path], 'check_site-config.xml')

template check_site_xml do
  source 'check_site.xml.erb'
end

jenkins_job 'check_site' do
  config check_site_xml
end
