# Troubleshooting

## HTTP Errors

**401, 403 Unauthorized - bad clock**

Occasionally, the system date/time will drift between client and server.  If this drift is greater than a couple of minutes, the Chef Server will throw a 401 unauthorized and the request will not be forwarded to the Compliance server.

On the Chef Server you can see this in the following logs:
```
# chef-server-ctl tail

==> /var/log/opscode/nginx/access.log <==
192.168.200.102 - - [28/Aug/2016:14:57:36 +0000]  "GET /organizations/brewinc/nodes/vagrant-c0971990 HTTP/1.1" 401 "0.004" 93 "-" "Chef Client/12.14.38 (ruby-2.3.1-p112; ohai-8.19.2; x86_64-linux; +https://chef.io)" "127.0.0.1:8000" "401" "0.003" "12.14.38" "algorithm=sha1;version=1.1;" "vagrant-c0971990" "2013-09-25T15:00:14Z" "2jmj7l5rSw0yVb/vlWAYkK/YBwk=" 1060

==> /var/log/opscode/opscode-erchef/crash.log <==
2016-08-28 14:57:36 =ERROR REPORT====
{<<"method=GET; path=/organizations/brewinc/nodes/vagrant-c0971990; status=401; ">>,"Unauthorized"}

==> /var/log/opscode/opscode-erchef/erchef.log <==
2016-08-28 14:57:36.521 [error] {<<"method=GET; path=/organizations/brewinc/nodes/vagrant-c0971990; status=401; ">>,"Unauthorized"}

==> /var/log/opscode/opscode-erchef/current <==
2016-08-28_14:57:36.52659 [error] {<<"method=GET; path=/organizations/brewinc/nodes/vagrant-c0971990; status=401; ">>,"Unauthorized"}

==> /var/log/opscode/opscode-erchef/requests.log.1 <==
2016-08-28T14:57:36Z erchef@127.0.0.1 method=GET; path=/organizations/brewinc/nodes/vagrant-c0971990; status=401; req_id=g3IAA2QAEGVyY2hlZkAxMjcuMC4wLjEBAAOFrgAAAAAAAAAA; org_name=brewinc; msg=bad_clock; couchdb_groups=false; couchdb_organizations=false; couchdb_containers=false; couchdb_acls=false; 503_mode=false; couchdb_associations=false; couchdb_association_requests=false; req_time=1; user=vagrant-c0971990; req_api_version=1;

```
Additionally, the chef_gate log will contain a similar message:
```
# /var/log/opscode/chef_gate/current
2016-08-28_15:01:34.88702 [GIN] 2016/08/28 - 15:01:34 | 401 |   13.650403ms | 192.168.200.102 |   POST    /compliance/organizations/brewinc/inspec
2016-08-28_15:01:34.88704 Error #01: Authentication failed. Please check your system's clock.
```

**401 Token and Refresh Token Authentication**

In the event of a malformed or unset token, the Chef Compliance server will log the token error:
```
==> /var/log/chef-compliance/core/current <==
2016-08-28_20:41:46.17496 20:41:46.174 ERR => Token authentication: %!(EXTRA *errors.errorString=malformed JWS, only 1 segments)
2016-08-28_20:41:46.17498 [GIN] 2016/08/28 - 20:41:46 | 401 |      53.824µs | 192.168.200.102 |   GET     /owners/base/compliance/linux/tar

==> /var/log/chef-compliance/nginx/compliance.access.log <==
192.168.200.102 - - [28/Aug/2016:21:23:46 +0000] "GET /api/owners/base/compliance/linux/tar HTTP/1.1" 401 0 "-" "Ruby"
```
