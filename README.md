# verify_package_sign_id

**Disclaimer**: This project scripts are `NOT` delivered and/or released by Red Hat. This is an independent project to help customers and Red Hat Support team to analyze some data, and help with the troubleshooting.

This script will do some queries, just to collect some db/rpm information.

Please, execute this script on your Satellite / Foreman server.

---

## To Deploy
```
wget https://raw.githubusercontent.com/Qikfix/verify_package_sign_id/main/verify_package_sign_id.sh
chmod +x verify_package_sign_id.sh
```
And that's it! :-)

---

## Now, let' s take a look on how this works.

When calling the script with no parameters, a package name will be request.
```
./verify_package_sign_id.sh
Please, call ./verify_package_sign_id.sh <package_name>
exiting ...
```


When passing a package name that is not in the DB/Satellite/Foreman, the same will return the message `No package found ...` and will exit
```
./verify_package_sign_id.sh tralala
No package found ...
exiting ...
```

When passing a valid package name, the output file `/tmp/result.csv` will be created
```
./verify_package_sign_id.sh iptraf-ng
Please, wait ...
Please, check the /tmp/result.csv file
```


And the content will be as presented next
```
cat /tmp/result.csv
name,version,release,key_id,artifact_path
iptraf-ng,1.1.4,18.el8,NO_KEY,ARTIFACT_NOT_PRESENT_PROBABLY_ONDEMAND
iptraf-ng,1.1.4,4.el7,NO_KEY,ARTIFACT_NOT_PRESENT_PROBABLY_ONDEMAND
iptraf-ng,1.1.4,6.el7,NO_KEY,ARTIFACT_NOT_PRESENT_PROBABLY_ONDEMAND
iptraf-ng,1.1.4,7.el7,NO_KEY,ARTIFACT_NOT_PRESENT_PROBABLY_ONDEMAND
iptraf-ng,1.2.1,2.el8,Key ID 199e2f91fd431d51,/var/lib/pulp/media/artifact/49/a654577bea798d44d1e216e72a5a7c31f14ef60361df77d496fe60c37b84ca
iptraf-ng,1.2.1,4.el9,NO_KEY,ARTIFACT_NOT_PRESENT_PROBABLY_ONDEMAND
```

Above, we can see all the versions and releases. However, once some of them are not around, there is no way to know the `Key ID`. This will be available only for the packages that are already synced on Satellite.

Here, we can see the `Key ID` of such package, in that specific version and release, and also, the path to the artifact in the filesystem.
```
iptraf-ng,2.el8,1.2.1,Key ID 199e2f91fd431d51,/var/lib/pulp/media/artifact/49/a654577bea798d44d1e216e72a5a7c31f14ef60361df77d496fe60c37b84ca
```

If you would like to double-check, you can execute the step below
```
rpm -qpi /var/lib/pulp/media/artifact/49/a654577bea798d44d1e216e72a5a7c31f14ef60361df77d496fe60c37b84ca
Name        : iptraf-ng
Version     : 1.2.1
Release     : 2.el8
Architecture: x86_64
Install Date: (not installed)
Group       : Applications/System
Size        : 391458
License     : GPLv2+
Signature   : RSA/SHA256, Thu 28 Jan 2021 03:26:14 PM UTC, Key ID 199e2f91fd431d51
Source RPM  : iptraf-ng-1.2.1-2.el8.src.rpm
Build Date  : Thu 28 Jan 2021 11:56:28 AM UTC
Build Host  : x86-vm-56.build.eng.bos.redhat.com
Relocations : (not relocatable)
Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
Vendor      : Red Hat, Inc.
URL         : https://github.com/iptraf-ng/iptraf-ng/
Summary     : A console-based network monitoring utility
Description :
IPTraf-ng is a console-based network monitoring utility.  IPTraf gathers
data like TCP connection packet and byte counts, interface statistics
and activity indicators, TCP/UDP traffic breakdowns, and LAN station
packet and byte counts.  IPTraf-ng features include an IP traffic monitor
which shows TCP flag information, packet and byte counts, ICMP
details, OSPF packet types, and oversized IP packet warnings;
interface statistics showing IP, TCP, UDP, ICMP, non-IP and other IP
packet counts, IP checksum errors, interface activity and packet size
counts; a TCP and UDP service monitor showing counts of incoming and
outgoing packets for common TCP and UDP application ports, a LAN
statistics module that discovers active hosts and displays statistics
about their activity; TCP, UDP and other protocol display filters so
you can view just the traffic you want; logging; support for Ethernet,
FDDI, ISDN, SLIP, PPP, and loopback interfaces; and utilization of the
built-in raw socket interface of the Linux kernel, so it can be used
on a wide variety of supported network cards.
```

Please, check the [Issues page](https://github.com/Qikfix/verify_package_sign_id/issues) for the features that will be around soon, if your request is not there, please, feel free to create a [new issue](https://github.com/Qikfix/verify_package_sign_id/issues/new).


We hope you enjoy it.