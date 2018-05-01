yum_repository 'jenkins-ci' do
  description 'Jenkins CI repo'
  baseurl 'https://pkg.jenkins.io/redhat-stable'
  gpgkey 'https://pkg.jenkins.io/redhat-stable/jenkins.io.key'
  action :create
end

%w(java-1.8.0-openjdk jenkins).each do |pkg|
  package pkg do
    action :install
  end
end

template '/etc/sysconfig/jenkins' do
  source 'jenkins.erb'
end

service 'jenkins' do
  action [:start, :enable]
  subscribes :restart, 'template[/etc/sysconfig/jenkins]', :immediately
end

ruby_block 'wait until Jenkins will be available' do
  block do
    seconds = 10
    done = false
    while seconds > 0 and !done
      Timeout::timeout(seconds) do
        begin
          TCPSocket.new('127.0.0.1', 8080).close
          puts "#{seconds} left"
          done = true
        rescue
          exit if seconds < 1
          print "."
          # if refuses immediately, try to connect in 1 second again
          sleep 1
          seconds = seconds-1
        end
      end
    end
  end
  action :run
end

check_site_xml = File.join(Chef::Config[:file_cache_path], 'check_site-config.xml')

template check_site_xml do
  source 'check_site.xml.erb'
  notifies :run, 'execute[update jenkins job]', :immediately
end

execute 'update jenkins job' do
  command "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 update-job check_site < #{check_site_xml}"
  action :nothing
  only_if 'java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 list-jobs | grep check_site'
end

execute 'add jenkins job' do
  command "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 create-job check_site < #{check_site_xml}"
  not_if 'java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 list-jobs | grep check_site'
end
