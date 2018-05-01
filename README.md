Vagrant with chef-zero provisioner
=============================

Brief description
-----

This is a simple example how to use chef provisioner in the Vagrant

Four servers are created in this example:
* two web servers (Apache) with IPs 192.168.100.101, 192.168.100.102; port 80/tcp
* load balancer (HAProxy) with IP 192.168.100.10; port 80/tcp
* Jenkins server with IP 192.168.100.11

Jenkins is used for periodically checking website. Jenkins is accessible by url http://192.168.100.11:8080

Usage
-----
VirtualBox extension is required for chef provisioning, so vagrant-vbguest plugin should be installed

```
vagrant plugin install vagrant-vbguest
```

Simple example:
```
cd simple
vagrant up
```

If we want to use Berkshelf, we should install plugin vagrant-berkshelf and ChefDK (https://downloads.chef.io/chefdk)

Berkshelf example:
```
cd with_berkshelf
vagrant up
```
