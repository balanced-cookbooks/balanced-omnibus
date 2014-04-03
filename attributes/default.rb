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

default['balanced-omnibus']['project'] = 'balanced'

# Force binary install
default['nodejs']['install_method'] = 'binary'

default['nodejs']['version'] = '0.10.26'
default['nodejs']['checksum_linux_x64'] = '305bf2983c65edea6dd2c9f3669b956251af03523d31cf0a0471504fd5920aac'
default['nodejs']['npm'] = '1.4.4'