class nagios::contact(
  $contacts     = $nagios::master::contacts,
  $contactgroups = $nagios::master::contactgroups,
) inherits nagios::master {

  nagios::contact::contacts { $contacts[user]:
    alias   => $contacts[alias],
    email   => $contacts[email],
    group   => $contacts[group],
    notify  => Exec['fix-permissions'],
    require => File["/etc/${masterdir}/${master_proj_name}"],
  }

  nagios::contact::contactgroups { $contactgroups[group]:
    alias   => $contactgroups[alias],
    notify  => Exec['fix-permissions'],
    require => File["/etc/${masterdir}/${master_proj_name}"],
  }
}
