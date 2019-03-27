#!/usr/bin/python

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

import time
import requests
import json
import sys
import getopt
import datetime
from time import mktime
from datetime import timedelta
from requests.auth import HTTPBasicAuth

def main(argv):
    try:
        opts, args = getopt.getopt(argv,"hSn:a:H:t:u:p:",["name=","age=","host=","timeout=","ssl","esuser=","espass="])
    except getopt.GetoptError:
        print 'elasticsearch_backup.py -n <name> -a <max backup age> -H <elastic-host> -t timeout [--ssl] [--esuser <username>] [--espass <password>]'
        sys.exit(2)

    proto = "http"
    es_user = None
    es_pass = None

    if opts:
        for opt, arg in opts:
            if opt == '-h':
                print 'elasticsearch_backup.py -n <name> -a <max backup age> -H <elastic-host> -t timeout [--ssl] [--esuser <username>] [--espass <password>]'
                sys.exit()
            elif opt in ("-n", "--name"):
                name = arg
            elif opt in ("-a", "--age"):
                age = int(arg)
            elif opt in ("-H", "--host"):
                host = arg
            elif opt in ("-S", "--ssl"):
                proto = "https"
            elif opt in ("-t", "--timeout"):
                timeout = int(arg)
            elif opt in ("-u", "--esuser"):
                es_user = arg
            elif opt in ("-p", "--espass"):
                es_pass = arg
    else:
        print 'elasticsearch_backup.py -n <name> -a <max backup age> -H <elastic-host> -t timeout [--ssl] [--esuser <username>] [--espass <password>]'
        sys.exit(2)

    delete_old_snapshots(host, name, age, proto, es_user, es_pass)
    create_snapshot(host, name, timeout, proto, es_user, es_pass)


def delete_old_snapshots(host, name, age, proto, es_user, es_pass):
    keep_backup_date = datetime.datetime.now() - timedelta(days=age)
    keep_miliseconds = 1000*mktime(keep_backup_date.timetuple())

    snapshots = get_snapshots(host, name, proto, es_user, es_pass)

    for snapshot in snapshots['snapshots']:
        if snapshot['end_time_in_millis'] < keep_miliseconds:
            try:
                if es_user is None or es_pass is None:
                    r = requests.delete(proto + "://" + host + ":9200/_snapshot/" + name + "/" + snapshot['snapshot'])
                else:
                    r = requests.delete(proto + "://" + host + ":9200/_snapshot/" + name + "/" + snapshot['snapshot'], auth=HTTPBasicAuth(es_user, es_pass))
            except requests.Timeout, e:
                print 'Time-out on delete of snapshot'
                exit(2)
            if r.status_code != 200:
                print 'HTTP response is not 200 when trying to delete a snapshot'
                try:
                    response = r.json()
                    print response['error']
                except ValueError:
                    print 'No JSON response'
                exit(2)

def get_snapshots(host, name, proto, es_user, es_pass):
    try:
        if es_user is None or es_pass is None:
            r = requests.get(proto + "://" + host + ":9200/_snapshot/" + name + "/_all")
        else:
            r = requests.get(proto + "://" + host + ":9200/_snapshot/" + name + "/_all", auth=HTTPBasicAuth(es_user, es_pass))
    except requests.Timeout, e:
        print 'Time-out when querying for snapshots'
        exit(2)
    if r.status_code != 200:
        print 'HTTP response is not 200 when requesting snapshots'
        try:
            response = r.json()
            print response['error']
        except ValueError:
            print 'No JSON response'
        exit(2)

    response = r.json()
    return response

def create_snapshot(host, name, timeout, proto, es_user, es_pass):
    snapshot_id = time.strftime("%y_%m_%d_%H_%M_%S")
    try:
        if es_user is None or es_pass is None:
            r = requests.put(proto + "://" + host + ":9200/_snapshot/" + name +"/" + snapshot_id + "?wait_for_completion=true", timeout=timeout)
        else:
            r = requests.put(proto + "://" + host + ":9200/_snapshot/" + name +"/" + snapshot_id + "?wait_for_completion=true", timeout=timeout, auth=HTTPBasicAuth(es_user, es_pass))
    except requests.Timeout, e:
        print 'Took longer than '+ timeout +' seconds to get a response when trying to add a snapshot'
        exit(2)

    if r.status_code != 200:
        print 'HTTP response is not 200 when adding a snapshot'
        try:
            response = r.json()
            print response['error']
        except ValueError:
            print 'No JSON response'
        exit(2)

    response = r.json()

    if response['snapshot']['state'] != 'SUCCESS':
        print 'Return state is not success'
        exit(2)

if __name__ == "__main__":
   main(sys.argv[1:])
