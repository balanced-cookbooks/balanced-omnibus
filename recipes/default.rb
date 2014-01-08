#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2014, Balanced, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt' if platform_family?('debian', 'ubuntu')

node.set['omnibus']['install_dir'] = "/opt/#{node['balanced-omnibus']['project']}"

include_recipe 'git'
include_recipe 'omnibus'

c = shell_out!('mount')
unless c.stdout.include?("on #{node['balanced-omnibus']['dir']} type vboxsf")
  directory node['balanced-omnibus']['dir'] do
    owner node['omnibus']['build_user']
    mode '755'
  end

  git node['balanced-omnibus']['dir'] do
    repository 'https://github.com/balanced/omnibus-balanced.git'
    revision 'master'
    user node['omnibus']['build_user']
  end
end

# Create pip config
directory "#{node['balanced-omnibus']['dir']}/.pip" do
  owner 'root'
  group 'root'
  mode '600'
end

template "#{node['balanced-omnibus']['dir']}/.pip/pip.conf" do
  owner 'root'
  group 'root'
  mode '600'
  source 'pip.conf.erb'
  variables password: citadel['omnibus/devpi_password'].strip
end

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '600'
end

file '/root/.ssh/deploy.pem' do
  owner 'root'
  group 'root'
  mode '600'
  content citadel['deploy_key/deploy.pem']
end

template '/root/.ssh/config' do
  owner 'root'
  group 'root'
  mode '600'
  source 'ssh_config.erb'
end

{
  'bundle install' => 'bundle install --binstubs --path vendor/bundle',
  'rm pkg/*' => "rm -f #{node['balanced-omnibus']['dir']}/pkg/#{node['balanced-omnibus']['project']}*",
  'omnibus build' => "bin/omnibus build project #{node['balanced-omnibus']['project']}",
}.each do |name, cmd|
  rbenv_execute name do
    command cmd
    ruby_version node['omnibus']['ruby_version']
    cwd node['balanced-omnibus']['dir']
    user node['omnibus']['build_user']
    environment 'HOME' => node['balanced-omnibus']['dir']
  end
end
