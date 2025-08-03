.ONESHELL:

WORKERS      = $(notdir $(wildcard nodes/workers/*.yaml))
CONTROLPLANE = $(notdir $(wildcard nodes/controlplane/*.yaml))
PATCHES      = $(addprefix --config-patch @, $(wildcard patches/*.yaml))
SECRETS_FILE = secrets.yaml

CLUSTER_NAME = homelab
API_ENDPOINT = https://ottawa.lan:6443

FACTORY_URL   := https://factory.talos.dev/schematics
TALOS_VERSION := 1.10.5

EXTRA_UPGRADE_FLAGS :=

empty :=
space := $(empty) $(empty)
comma := ,

.PHONY: config clean

config: config-control config-workers

clean:
	@rm -rf generated

################################################################################

.PHONY: help

help:
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  config                  Generate configuration files for all nodes"
	@echo "    config-control          Generate config files for controlplane nodes"
	@echo "    config-workers          Generate config files for worker nodes"
	@echo "  apply                   Apply configuration files to all nodes"
	@echo "    apply-control-<node>    Apply config file to controlplane node"
	@echo "    apply-worker-<node>     Apply config file to worker node"
	@echo "  upgrade                 Upgrade all nodes to desired installer image"
	@echo "    upgrade-control         Upgrade only controlplane nodes"
	@echo "    upgrade-workers         Upgrade only worker nodes"
	@echo "  help                    Display this help message"
	@echo "  clean                   Remove generated configuration files"


################################################################################

.PHONY: config-control config-workers

config-control: $(addprefix generated/controlplane/, $(CONTROLPLANE))

config-workers: $(addprefix generated/workers/, $(WORKERS))

generated/workers/%.yaml: nodes/workers/%.yaml generated/installers/%
	@mkdir -p $(dir $@)
	@echo "Generating config file for worker node $*"
	@talosctl gen config --with-secrets $(SECRETS_FILE) \
		--output-types worker $(PATCHES) --config-patch @$< --output $@ \
		--install-image $$(cat generated/installers/$*) \
		$(CLUSTER_NAME) $(API_ENDPOINT)

generated/controlplane/%.yaml: nodes/controlplane/%.yaml generated/installers/%
	@mkdir -p $(dir $@)
	@echo "Generating config file for controlplane node $*"
	@talosctl gen config --with-secrets $(SECRETS_FILE) \
		--output-types controlplane $(PATCHES) --config-patch @$< --output $@ \
		--install-image $$(cat generated/installers/$*) \
		$(CLUSTER_NAME) $(API_ENDPOINT)

################################################################################

.PHONY: upgrade upgrade-control upgrade-workers upgrade-worker-% upgrade-control-%

upgrade: upgrade-control upgrade-workers

upgrade-control: $(addprefix upgrade-control-, $(basename $(CONTROLPLANE)))

upgrade-control-%: generated/installers/%
	@echo "Upgrading control plane node $*"
	@talosctl upgrade $(EXTRA_UPGRADE_FLAGS) --image $$(cat $<) --preserve -n $*

upgrade-workers: $(addprefix upgrade-worker-, $(basename $(WORKERS)))

upgrade-worker-%: generated/installers/%
	@echo "Upgrading worker node $*"
	@talosctl upgrade $(EXTRA_UPGRADE_FLAGS) --image $$(cat $<) --preserve -n $*

################################################################################

.PHONY: apply apply-control-% apply-worker-%

apply: $(addprefix apply-control-, $(basename $(CONTROLPLANE)))
apply: $(addprefix apply-worker-, $(basename $(WORKERS)))

apply-control-%: generated/controlplane/%.yaml
	@echo "Applying config on controlplane node $*"
	@talosctl apply-config -n $* --file generated/controlplane/$*.yaml

apply-worker-%: generated/workers/%.yaml
	@echo "Applying config on worker node $*"
	@talosctl apply-config -n $* --file generated/workers/$*.yaml

################################################################################

.PHONY: all-images

all-images: $(addprefix generated/installers/, $(basename $(WORKERS)) $(basename $(CONTROLPLANE)))

generated/installers/%:
	@mkdir -p $(dir $@)
	@echo "Generating installer ID file for node $*"
	[ -f schematics/$*.yaml ] \
		&& SCHEMATIC="schematics/$*.yaml" \
		|| SCHEMATIC="schematics/default.yaml"
	@echo "Using schematic file: $${SCHEMATIC}"
	IMAGE_ID=$$(curl -s --data-binary @$${SCHEMATIC} $(FACTORY_URL) | jq -r '.id')
	echo -n factory.talos.dev/installer/$${IMAGE_ID}:v$(TALOS_VERSION) > $@
