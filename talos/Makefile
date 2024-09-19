WORKERS      = $(notdir $(wildcard nodes/workers/*.yaml))
CONTROLPLANE = $(notdir $(wildcard nodes/controlplane/*.yaml))
PATCHES      = $(addprefix --config-patch @, $(wildcard patches/*.yaml))
SECRETS_FILE = secrets.yaml

CLUSTER_NAME = homelab
API_ENDPOINT = https://ottawa.lan:6443

FACTORY_URL      := https://factory.talos.dev/schematics
TALOS_VERSION    := 1.7.6
INSTALL_IMAGE_ID := $(shell curl -s --data-binary @schematic.yaml $(FACTORY_URL) | jq -r '.id')
INSTALL_IMAGE    := factory.talos.dev/installer/$(INSTALL_IMAGE_ID):v$(TALOS_VERSION)

empty :=
space := $(empty) $(empty)
comma := ,

.PHONY: all clean

all: config-control config-workers

clean:
	@rm -rf generated

################################################################################




.PHONY: config-control config-workers

config-control: $(addprefix generated/controlplane/, $(CONTROLPLANE))

config-workers: $(addprefix generated/workers/, $(WORKERS))

generated/workers/%.yaml: nodes/workers/%.yaml
	@mkdir -p $(dir $@)
	@echo "Generating config file for worker node $*"
	@talosctl gen config --with-secrets $(SECRETS_FILE) \
		--output-types worker $(PATCHES) --config-patch @$< --output $@ \
		--install-image $(INSTALL_IMAGE) \
		$(CLUSTER_NAME) $(API_ENDPOINT)

generated/controlplane/%.yaml: nodes/controlplane/%.yaml
	@mkdir -p $(dir $@)
	@echo "Generating config file for controlplane node $*"
	@talosctl gen config --with-secrets $(SECRETS_FILE) \
		--output-types controlplane $(PATCHES) --config-patch @$< --output $@ \
		--install-image $(INSTALL_IMAGE) \
		$(CLUSTER_NAME) $(API_ENDPOINT)

################################################################################

.PHONY: upgrade upgrade-control upgrade-workers

upgrade: upgrade-control upgrade-workers

upgrade-control: config-control
	@echo "Upgrading controlplane nodes"
	@talosctl upgrade --image $(INSTALL_IMAGE) -p \
		-n $(subst $(space),$(comma),$(basename $(CONTROLPLANE)))

upgrade-workers: config-workers
	@echo "Upgrading worker nodes"
	@talosctl upgrade --image $(INSTALL_IMAGE) \
		-n $(subst $(space),$(comma),$(basename $(WORKERS)))

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
