##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2014 - http://skyscrape.rs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# == Class: bacula
#
# This class is able to activate and configure bacula client
#
#
# === Parameters
#
# [*bu_server*]
#   Hostname of the backup server.
#
# [*dir_server*]
#   Directory server name.
#
# [*dir_password*]
#   Directory server password.
#
# [*sd_password*]
#   Storgae daemon password.
#
# [*fd_port*]
#   File daemon port.
#
# [*sd_port*]
#   Storgae daemon port.
#
# === Examples
#
# * Installation of bacula
#     class {'bacula':
#       bu_server    => 'backup.example.com',
#       dir_server   => 'backup-dir',
#       dir_password => 'dir_password',
#       sd_password  => 'sd_password'
#     }
#
class bacula(
  $bu_server                  = undef,
  $dir_server                 = undef,
  $dir_password               = undef,
  $sd_password                = undef,
  $fd_port                    = $bacula::params::fd_port,
  $sd_port                    = $bacula::params::sd_port,
  $manage_repo                = false,
  $elasticsearch_script_path  = $bacula::params::elasticsearch_script_path
  ) inherits bacula::params {

  if( $manage_repo == true ) {
    include bacula::repo
  }
  include bacula::install
  include bacula::config
  include bacula::service

  if( $manage_repo == true ){
    Class['bacula::repo'] -> Class['bacula::install'] -> Class['bacula::config'] -> Class['bacula::service']
  } else {
    Class['bacula::install'] -> Class['bacula::config'] -> Class['bacula::service']
  }
}
