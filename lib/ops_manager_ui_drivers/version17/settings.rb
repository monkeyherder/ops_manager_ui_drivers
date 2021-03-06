module OpsManagerUiDrivers
  module Version17
    module Settings
      def self.for(test_settings)
        settings_class = [Vcloud, Vsphere, AWS, OpenStack].find do |klass|
          klass.works_with?(test_settings.iaas_type)
        end or raise("Unsupported IaaS: #{test_settings.iaas_type.inspect}")
        settings_class.new(test_settings)
      end

      class Vcloud
        def self.works_with?(iaas_type)
          iaas_type == 'vcloud'
        end

        def initialize(test_settings)
          @test_settings = test_settings
        end

        def iaas_configuration_fields
          {
            'vcd_url'         => test_settings.ops_manager.vcloud.creds.url,
            'organization'    => test_settings.ops_manager.vcloud.creds.organization,
            'vcd_username'    => test_settings.ops_manager.vcloud.creds.user,
            'vcd_password'    => test_settings.ops_manager.vcloud.creds.password,
            'datacenter'      => test_settings.ops_manager.vcloud.vdc.name,
            'storage_profile' => test_settings.ops_manager.vcloud.vdc.storage_profile,
            'catalog_name'    => test_settings.ops_manager.vcloud.vdc.catalog_name,
          }
        end

        def advanced_infrastructure_config_fields
          { }
        end

        private

        attr_reader :test_settings
      end

      class Vsphere
        def self.works_with?(iaas_type)
          iaas_type == 'vsphere'
        end

        def initialize(test_settings)
          @test_settings = test_settings
        end

        def iaas_configuration_fields
          {
            'vcenter_ip'                   => test_settings.ops_manager.vcenter.creds.ip,
            'vcenter_username'             => test_settings.ops_manager.vcenter.creds.username,
            'vcenter_password'             => test_settings.ops_manager.vcenter.creds.password,
            'datacenter'                   => test_settings.ops_manager.vcenter.datacenter,
            'ephemeral_datastores_string'  => test_settings.ops_manager.vcenter.ephemeral_datastore,
            'persistent_datastores_string' => test_settings.ops_manager.vcenter.persistent_datastore,
            'bosh_vm_folder'               => test_settings.ops_manager.vcenter.bosh_vm_folder,
            'bosh_template_folder'         => test_settings.ops_manager.vcenter.bosh_template_folder,
            'bosh_disk_path'               => test_settings.ops_manager.vcenter.bosh_disk_path,
          }
        end

        def advanced_infrastructure_config_fields
          { }
        end

        private

        attr_reader :test_settings
      end

      class AWS
        def self.works_with?(iaas_type)
          iaas_type == 'aws'
        end

        def initialize(test_settings)
          @test_settings = test_settings
        end

        def iaas_configuration_fields
          {
            'access_key_id'     => test_settings.ops_manager.aws.aws_access_key,
            'secret_access_key' => test_settings.ops_manager.aws.aws_secret_key,
            'vpc_id'            => test_settings.ops_manager.aws.vpc_id,
            'security_group'    => test_settings.ops_manager.aws.security_group,
            'key_pair_name'     => test_settings.ops_manager.aws.key_pair_name,
            'ssh_private_key'   => test_settings.ops_manager.aws.ssh_key,
            'region'            => test_settings.ops_manager.aws.region,
            'encrypted'         => test_settings.ops_manager.aws.encrypt_disk,
          }
        end

        def advanced_infrastructure_config_fields
          { }
        end

        private

        attr_reader :test_settings
      end

      class OpenStack
        def self.works_with?(iaas_type)
          iaas_type == 'openstack'
        end

        def initialize(test_settings)
          @test_settings = test_settings
        end

        def iaas_configuration_fields
          {
            'identity_endpoint' => test_settings.ops_manager.openstack.identity_endpoint,
            'username'          => test_settings.ops_manager.openstack.username,
            'password'          => test_settings.ops_manager.openstack.password,
            'tenant'            => test_settings.ops_manager.openstack.tenant,
            'security_group'    => test_settings.ops_manager.openstack.security_group_name,
            'key_pair_name'     => test_settings.ops_manager.openstack.key_pair_name,
            'ssh_private_key'   => test_settings.ops_manager.openstack.ssh_private_key,
            'region'            => test_settings.ops_manager.openstack.region,
            'disable_dhcp'      => test_settings.ops_manager.openstack.disable_dhcp,
          }
        end

        def advanced_infrastructure_config_fields
          { 'connection_options' => test_settings.ops_manager.openstack.connection_options }
        end

        private

        attr_reader :test_settings
      end
    end
  end
end
