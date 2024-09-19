# Talos Configuration

Talos Linux is an immutable GNU/Linux distribution designed for Kubernetes. It's
built with security in mind, and given the declarative nature of machine
configuration, it's a great fit for a DevOps engineer's homelab.

The repository structure here is vaguely inspired by Mathias Pius' [Bare-metal
Kubernetes, Part I][mpius-bare-metal-p1] article. Compared to his setup, I split
the nodes into directories for control plane and worker nodes, and wrote a
Makefile to simplify the process of generating and applying machine
configuration. I also added a schematic for the installer image, which is POSTed
to the official Image Factory to compute a compliant image ID. The Makefile also
allow upgrading nodes based on the computed image ID.

[mpius-bare-metal-p1]: https://datavirke.dk/posts/bare-metal-kubernetes-part-1-talos-on-hetzner/

A less verbose explanation:

- `secrets.yaml` is encrypted by git-crypt and is the result of `talosctl gen
  secrets`.
- `schematic.yaml` is the schematic for the desired installed image.
- `nodes` contains patch files for each node based on their hostname.
- `patches` contains patches to be applied to all machine configuration.

Read the Makefile to get a list of recipes. The default goal is `all`.
