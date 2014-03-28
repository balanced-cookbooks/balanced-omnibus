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

include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'poise-ruby::ruby-210'
include_recipe 'python'
include_recipe 'nodejs'
include_recipe 'nodejs::npm'

# Create pip and aws config
%w(.pip .aws).each do |directory_name|
  directory "/root/#{directory_name}" do
    owner 'root'
    group 'root'
    mode '600'
  end
end

template '/root/.pip/pip.conf' do
  owner 'root'
  group 'root'
  mode '600'
  source 'pip.conf.erb'
  variables password: citadel['omnibus/devpi_password'].strip
end

template '/root/.aws/config' do
  source 'aws_config.erb'
  owner 'root'
  group 'root'
  mode  '644'
  variables(
      access_key_id: citadel['s3fs/aws_access_key_id'],
      secret_access_key: citadel['s3fs/aws_secret_access_key'],
      region: 'us-west-1'
  )
end

python_pip 'awscli'

# Create SSH config
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

# Basic packages
%w{
  dpkg-dev
  libxml2
  libxml2-dev
  libxslt1.1
  libxslt1-dev
  ncurses-dev
}.each {|pkg| package pkg }

# Install bundler
gem_package 'bundler' do
  gem_binary '/opt/ruby-210/bin/gem'
end

# Install NPM packages
%w{bower less}.each {|pkg| npm_package pkg}

# Omnibus cache directory
directory '/var/cache/omnibus' do
  owner 'root'
  group 'root'
  mode '755'
end
