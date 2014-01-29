# -*- mode: ruby -*-
# vi: set ft=ruby :

host_project_path = File.expand_path('../../omnibus-balanced', __FILE__)
guest_project_path = "/srv/omnibus-balanced"
projects = Dir["#{host_project_path}/config/projects/*.rb"].map{|path| File.basename(path, '.rb') }

Vagrant.require_plugin('vagrant-omnibus')
Vagrant.require_plugin('vagrant-berkshelf')

Vagrant.configure('2') do |config|

  config.vm.box = 'ubuntu-12.04'
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      'modifyvm', :id,
      '--memory', '1536',
      '--cpus', '2'
    ]
  end

  # Ensure a recent version of the Chef Omnibus packages are installed
  config.omnibus.chef_version = :latest

  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true

  config.vm.synced_folder host_project_path, guest_project_path

  projects.each do |project_name|
    config.vm.define project_name do |c|
      c.vm.hostname = "#{project_name}-omnibus-build-lab"

      # prepare VM to be an Omnibus builder
      c.vm.provision :chef_solo do |chef|
        chef.log_level = :debug
        chef.json = {
          'balanced-omnibus' => {
            project: project_name,
          },
          citadel: {
            access_key_id: ENV['BALANCED_AWS_ACCESS_KEY_ID'] || ENV['AWS_ACCESS_KEY_ID'] || ENV['ACCESS_KEY_ID'],
            secret_access_key: ENV['BALANCED_AWS_SECRET_ACCESS_KEY'] || ENV['AWS_SECRET_ACCESS_KEY'] || ENV['SECRET_ACCESS_KEY'],
          },
        }

        chef.run_list = %w{
          recipe[balanced-omnibus]
        }
      end

      c.vm.provision :shell, inline: <<-PROVISION.gsub(/^ {8}/, '')
        export PATH="/opt/ruby-210/bin:$PATH"
        cd #{guest_project_path}
        bundle install --binstubs --path vendor/bundle
        rm -f pkg/#{project_name}*
        rm -f /var/cache/omnibus/pkg/#{project_name}*
        bin/omnibus build project #{project_name}
      PROVISION
    end
  end
end
