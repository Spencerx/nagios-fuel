define nagios::service::services(
$command = false,
$group   = false,
) {


  $deployment_id = $::fuel_settings['deployment_id']

  notify{ "**** called service ${name} tag deployment_${deployment_id} *****": }

  @@nagios_service { "${deployment_id}_${::hostname}_${name}":
    ensure              => present,
    hostgroup_name      => $nagios::hostgroup,
    check_command       => $command,
    service_description => $name,
    host_name           => $::fqdn,
    target              => "/etc/${nagios::params::masterdir}/${nagios::master_proj_name}/${::hostname}_services.cfg",
    tag => "deployment_${deployment_id}"
  }
}
