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

require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

# https://github.com/test-kitchen/test-kitchen/issues/321
ENV['HOME'] = Etc.getpwuid(Process.uid).dir

# Set our path
ENV['PATH'] = "/opt/ruby-210/bin:#{ENV['PATH']}"

# Confirm that we can install internal packages
describe command('pip install --no-deps sterling') do
  it { should return_exit_status 0 }
end

# Confirm that we can clone private repos
describe command('rm -rf precog && git clone --depth 1 git@github.com:balanced/precog.git') do
  it { should return_exit_status 0 }
end

# Confirm bundler is installed
describe command('bundle --version') do
  it { should return_exit_status 0 }
end
