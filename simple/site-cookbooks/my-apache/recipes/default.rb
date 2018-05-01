#httpd_service 'default' do
#  action [:create, :start]
#end

package 'httpd' do
  action :install
end

service 'httpd' do
  action [:start, :enable]
end

template '/var/www/html/index.html' do
  path '/var/www/html/index.html'
  source 'index.html.erb'
end
