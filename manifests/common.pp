## This is class includes services from Array
class nagios::common inherits nagios {

  nagios::host::hosts { $::hostname: }
  #nagios::host::hostextinfo { $::hostname: }
  nagios::host::hostgroups { $hostgroup: }

  if $::virtual == 'physical' {
    $a_disks = split($::mountpoints, ',')
    nagios::common::add_disk { 'Add disks': }

    file{"/var/run/nagios":
      owner   => nagios,
      group   => nagios,
      mode    => '0644',
      recurse => true,
      ensure => directory
    }

    $a_interfaces = split($::interfaces, ',')
#    nagios::common::add_interface { 'Add interfaces': }
  }


  define add_disk($disk_count = size($a_disks), $current = 0) {
    if $current == $disk_count -1 {
      nagios::common::run_disk { $a_disks[$current]:
        disk => $a_disks[$current],
      }
    } else {
      $c_num = $current + 1

      nagios::common::add_disk { $a_disks[$current]:
        current => $c_num,
      }
      nagios::common::run_disk { $a_disks[$current]:
        disk => $a_disks[$current],
      }
    }
  }
  
  define run_disk($disk) {
    notify {"creating service for mountpoint ${disk}":}
    nagios::service::services { $disk:
      command => "nrpe_check_disk!80!90!${disk}"
    }
  }

  define add_interface($interface_count = size($a_interfaces), $current = 0) {
    if $current == $interface_count -1 {
      if $a_interfaces[$current] != ovs_system nagios::common::run_interface { $a_interfaces[$current]:
        interface => $a_interfaces[$current],
      }
    } else {
      $c_num = $current + 1

      nagios::common::add_interface { $a_interfaces[$current]:
        current => $c_num,
      }
      nagios::common::run_interface { $a_interfaces[$current]:
        interface => $a_interfaces[$current],
      }
    }
  }

  define run_interface($interface) {
    notify {"creating service for interface ${interface}":}
    nagios::service::services { $interface:
      command => "nrpe_check_iflocal!${interface}"
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
