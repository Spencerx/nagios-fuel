define nagios::host::hosts() {

  $deployment_id = $::fuel_settings['deployment_id']  
  notify{ "**** called hosts() on host ${::hostname} tag deployment_${deployment_id} *****": }

  @@nagios_host { "${name}_${deployment_id}":
    ensure     => present,
    alias      => $::hostname,
    use        => 'default-host',
    address    => $::fqdn,
    host_name  => $::fqdn,
    target     => "/etc/${nagios::params::masterdir}/${nagios::master_proj_name}/hosts.cfg",
    tag => "deployment_${deployment_id}"
  }
}
