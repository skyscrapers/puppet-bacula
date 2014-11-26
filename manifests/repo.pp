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

# == Class bacula::repo
#
# This class is called from bacula
#
class bacula::repo {
  if !defined(Class['apt']) {
    class { 'apt': }
  }

  if ($::lsbdistrelease == '10.04') {
    apt::source { 'skyscrapers-bacula':
      location    => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/ubuntu/',
      release     => 'lucid-skyscrapers',
      repos       => 'main',
      key         => '1BC1B9EF',
      key_source  => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/gpg.key',
      include_src => false,
    }
  } elsif ($::lsbdistrelease == '12.04') {
    apt::source { 'skyscrapers-bacula':
      location    => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/ubuntu/',
      release     => 'precise-skyscrapers',
      repos       => 'main',
      key         => '1BC1B9EF',
      key_source  => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/gpg.key',
      include_src => false,
    }
  } elsif ($::lsbdistrelease == '14.04') {
    apt::source { 'skyscrapers-bacula':
      location    => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/ubuntu/',
      release     => 'trusty-skyscrapers',
      repos       => 'main',
      key         => '1BC1B9EF',
      key_source  => 'http://skypackages.s3-website-eu-west-1.amazonaws.com/gpg.key',
      include_src => false,
    }
  }
}
