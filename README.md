# Yet Another Homelab

This repository contains every possible (non-sensitive) configuration file I'll
be using in building up my homelab. It is a constant work in progress, and will
hopefully supersede my k0s cluster.

## Purpose

Setting stuff up for people to use and watching them thrive while doing so is
something I have enjoyed doing for a long time. With my k0s cluster, it's been
no different. However, the I/O performance on the small-time provider I'm
renting the VMs from is not the best, and I've had to deal with corrupted files
and crashing services more times than I'd like to. Dedicated hardware hopefully
won't exhibit the same kind of behaviour.

Renting an entire server on the cloud is a bit too expensive, and I wouldn't get
any return on investment from it. So, I've decided to build a homelab instead.
While the upfront cost is high, the long-term benefits are worth it: at the very
least I'll learn from it.

## Hardware

This list will be updated as changes are made to this project's hardware
configuration.

### Servers

- 1x Dell Optiplex 3080 Micro (i5-10500T, 64 GB RAM, 256 GB NVMe SSD)
- 1x Dell Optiplex 7070 Micro (i5-8500T, 16 GB RAM, 256 GB NVMe SSD)
- 3x Lenovo Tiny M920q (i5-8500T, 16 GB RAM, 256 GB NVMe SSD)

### Networking

- 1x NETGEAR GS308 8-port 1Gbps switch

### Future Plans

A NAS is planned for the near future, since 256 GB of NVMe storage is certainly
not enough. It would also be good to separate the operating system from the data
we're storing, so that we can easily move the data around.

The cluster control plane is currently on a single node that also allows
scheduling of workloads. This isn't ideal, but it's a start. Perhaps in the
future I'll add a couple more nodes to the cluster to make it more resilient.

A less powerful machine to act as a load balancer would be nice, but it's not a
requirement at the moment. It would be good to have it configured by the cluster
automatically, so I can just forget about it.

The networking equipment could be upgraded to at least 2.5 Gbps, but 1 Gbps
hardware is much more affordable and speeds above 1 Gbps are unlikely to be
needed in the near future.

## Software

The cluster has been set up using Talos, an immutable Linux distribution built
specifically for Kubernetes. It's production ready and its configuration files
are declarative. Given this project exists and is as mature as it is, I luckily
don't have to deal with NixOS or maintaining both OS and cluster.
