## This is class update the nagios master when new nodes are added

class nagios::update () inherits nagios::master {

  notify { "***** Beginning update of nagios master on host ${::hostname} *****": }

  include nagios::host
  include nagios::service
  include nagios::command
  include nagios::contact

}
