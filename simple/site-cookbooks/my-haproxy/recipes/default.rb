package 'haproxy' do
  action :install
end

service 'haproxy' do
  action [:start, :enable]
  subscribes :restart, 'template[/etc/haproxy/haproxy.cfg]', :immediately
end

template '/etc/haproxy/haproxy.cfg' do
  path '/etc/haproxy/haproxy.cfg'
  source 'haproxy.cfg.erb'
end
