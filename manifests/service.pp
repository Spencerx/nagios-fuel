class nagios::service(
  $templateservice = $nagios::master::templateservice,
) inherits nagios::master {


  $deployment_id = $::fuel_settings['deployment_id']
  
  $tag = "deployment_${deployment_id}"
  
  notify{ "**** importing services with tag ${tag} *****": }

  Nagios_service <<|tag==$tag|>> {
    use     => $templateservice['name'],
    notify  => Exec['fix-permissions'],
    require => File["/etc/${masterdir}/${master_proj_name}"],
  }

}
