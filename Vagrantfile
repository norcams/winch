# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

settings = YAML::load_file(File.expand_path('vagrant/nodes.yaml', File.dirname(__FILE__)))
settings['nodes'].each do |node|
    node.merge!(settings['node_defaults']) { |key, nval, tval | nval }
    node['box_url'] = settings['boxes'][node['box']]
end

Vagrant.configure("2") do |config|
    settings['nodes'].each_with_index do |node, i|
        config.vm.define node['name'] do |box|
            box.vm.hostname = node['name'] + "." + node['domain']
            box.vm.box = node['box']
            box.vm.box_url = node['box_url']

            node['networks'].each do |net|
                ip = settings['networks'][net] + ".#{i+11}"
                box.vm.network :private_network, ip: ip
            end

            box.vm.provider :virtualbox do |vb|
                if  node['cpus'].to_i > 1
                    vb.customize ["modifyvm", :id, "--ioapic", "on"]
                end
                vb.customize ["modifyvm", :id, "--cpus", node['cpus']]
                vb.customize ["modifyvm", :id, "--memory", node['memory']]
                vb.customize ["modifyvm", :id, "--name", node['name']]
            end

            box.vm.provision :shell, :path => "vagrant/install-puppet.sh"
            box.vm.provision :shell, :path => "vagrant/virbr0-fix.sh"
            box.vm.provision :puppet do |puppet|
                puppet.manifests_path = "puppet/manifests"
                puppet.module_path = [ "puppet/modules", "puppet/site" ]
                puppet.manifest_file  = "vagrant.pp"
                puppet.hiera_config_path = "puppet/hiera.yaml"
                puppet.working_directory = "/vagrant/puppet"
            end
        end
    end
end

