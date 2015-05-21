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

# == Class bacula::config
#
# This class is called from bacula
#
class bacula::config {
  file {
    '/usr/local/bacula/etc/bacula-fd.conf':
      ensure  => file,
      content => template ('bacula/usr/local/bacula/etc/bacula-fd.conf.erb'),
      owner   => root,
      group   => root,
      mode    => '0640',
      require => Class['bacula::install'],
      notify  => Class['bacula::service'];

    '/root/scripts/prebacula.sh':
      ensure  => file,
      content => template('bacula/root/scripts/prebacula.sh.erb'),
      owner   => root,
      group   => root,
      mode    => '0700',
      require => File['/root/scripts'];

    '/root/bacula':
      ensure => directory,
      mode   => '0755',
      owner  => root,
      group  => root;

    '/root/scripts':
      ensure => directory,
      mode   => '0755',
      owner  => root,
      group  => root;

    '/root/scripts/postbacula.sh':
      ensure => file,
      source => 'puppet:///modules/bacula/root/scripts/postbacula.sh',
      owner => root,
      group => root,
      mode => '0755',
      require => File['/root/scripts'];

    '/root/scripts/removeBackupTmpFolders.sh':
      ensure => file,
      source => 'puppet:///modules/bacula/root/scripts/removeBackupTmpFolders.sh',
      owner  => root,
      group  => root,
      mode   => '0755',
      require => File['/root/scripts'];

    '/etc/cron.d/backupcleanup':
      ensure => file,
      source => 'puppet:///modules/bacula/etc/cron.d/backupcleanup',
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  @@file {
    "/usr/local/bacula/etc/template.dir.d/$::realfqdn.conf":
      ensure => file,
      content => template ('bacula/usr/local/bacula/etc/conf.dir.d/bacula_client_dir_template.conf.erb'),
      owner => root,
      group => root,
      tag => 'baculaconfig',
      mode => '0644';
  }

  @@file {
    "/usr/local/bacula/etc/template.sd.d/$::realfqdn.conf":
      ensure => file,
      content => template ('bacula/usr/local/bacula/etc/conf.sd.d/bacula_client_sd_template.conf.erb'),
      owner => root,
      group => root,
      tag => 'baculaconfig',
      mode => '0644';
  }

  @@file {
    "/var/backups/bacula/$::realfqdn":
      ensure => directory,
      mode => '0755',
      owner => root,
      group => root,
      tag => 'baculaconfig';
  }
}
