## This is class includes services from Array
class nagios::common inherits nagios {

  nagios::host::hosts { $::hostname: }
  #nagios::host::hostextinfo { $::hostname: }
  nagios::host::hostgroups { $hostgroup: }

  if $::virtual == 'physical' {
    $a_disks = split($::disks, ',')
    nagios::service::services { $a_disks:
    }

    $a_interfaces = split($::interfaces, ',')
    nagios::service::services { $a_interfaces:
    }
  }

## If you use puppet 3.1 or higher use this function instead below code
#
#nagios_services_export( $services, $services_list,
#{
#  'hostgroup_name'      => $hostgroup,
#  'target'              => "/etc/${nagios::params::masterdir}/${nagios::master_proj_name}/${::hostname}_services.cfg"
#})

  define runservice($service) {
    notify {$nagios::params::services_list[$service]:}
    nagios::service::services { $service:
      command => $nagios::params::services_list[$service]
    }
  }

  define addservice($services_count = size($nagios::services_), $current = 0) {
    if $current == $services_count -1 {
      nagios::common::runservice { $nagios::services_[$current]:
      service => $nagios::services_[$current],
      }
    } else {
      $c_num = $current + 1

      nagios::common::addservice { $nagios::services_[$current]:
        current => $c_num,
      }
      nagios::common::runservice { $nagios::services_[$current]:
        service => $nagios::services_[$current],
      }
    }
  }  

  nagios::common::addservice { 'Add services': }
}
