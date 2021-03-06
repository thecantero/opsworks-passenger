directory node[:nginx][:custom_package][:package_location] do
  action :create
  recursive true
  owner "root"
  group "root"
end

package_file = node[:nginx][:custom_package][:source].split('/').last
remote_file "#{node[:nginx][:custom_package][:package_location]}#{package_file}" do
  source node[:nginx][:custom_package][:source]
  action :create
  owner "root"
  group "root"
end

package "nginx" do
  source "#{node[:nginx][:custom_package][:package_location]}#{package_file}"
  not_if "nginx -v | grep #{node[:nginx][:version]}"
end

# We are deleting default files packaged with the nginx rpm
file "/etc/nginx/conf.d/default.conf" do
  action :delete
end

file "/etc/nginx/conf.d/example_ssl.conf" do
  action :delete
end
