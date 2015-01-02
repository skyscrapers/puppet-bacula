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

# == Class: bacula::elasticsearch
#
# This class is able to activate bacula backups for elasticsearch
#
#
# === Parameters
#
# [*name*]
#   Name of snapshot repository.
#
# [*location]
#   Where to save the snapshots on the filesystem.
#
# [*script_path*]
#   Where to place the backup script.
#
# === Examples
#
# * Installation of bacula
#     class {'bacula::elasticsearch':
#       name        => 'my_backup',
#       location    => '/var/backup/elasticsearch',
#       script_path => '/root'
#     }
#
class bacula::elasticsearch(
  $name        = undef,
  $location    = undef,
  $script_path = $bacula::params::elasticsearch_script_path,
) {

  exec { 'Add snapshot to elasticsearch':
    command   => "curl -XPUT \'http://localhost:9200/_snapshot/${name}\' -d \'{\"type\": \"fs\",\"settings\": {\"location\": \"${location}\",\"compress\": true}}\'",
    unless    => "curl -XGET \'http://localhost:9200/_snapshot/_all\' | grep ${name}",
    path      => '/usr/bin/:/bin/',
    logoutput => true,
  }

  file {
    "${script_path}/elasticsearch_backup.py":
      ensure => file,
      source => 'puppet:///modules/bacula/elasticsearch/elasticsearch_backup.py',
      owner => root,
      group => root,
      mode => '0775';

    $location:
      ensure => directory,
      mode   => '0755',
      owner  => elasticsearch,
      group  => elasticsearch;
  }
}
