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

name 'balanced-omnibus'
version '1.0.12'

maintainer 'Noah Kantrowitz'
maintainer_email 'noah@coderanger.net'
license 'Apache 2.0'
description 'Configure a server to run omnibus-balanced builds'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

depends 'apt'
depends 'balanced-citadel'
depends 'build-essential'
depends 'git'
depends 'poise-ruby'
depends 'python'
depends 'nodejs', '~> 1.3'
depends 'npm', '~> 0.1'
