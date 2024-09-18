WORKERS = $(notdir $(wildcard nodes/workers/*.yaml))
CONTROLPLANE = $(notdir $(wildcard nodes/controlplane/*.yaml))
PATCHES = $(addprefix --config-patch @, $(wildcard patches/*.yaml))
SECRETS_FILE = secrets.yaml

CLUSTER_NAME = homelab
API_ENDPOINT = https://ottawa.lan:6443

TALOS_VERSION = 1.7.6
INSTALL_IMAGE_ID = $(shell curl -sX POST --data-binary @schematic.yaml https://factory.talos.dev/schematics | jq -r '.id')
INSTALL_IMAGE = factory.talos.dev/installer/$(INSTALL_IMAGE_ID):v$(TALOS_VERSION)

empty :=
space := $(empty) $(empty)
comma := ,

.PHONY: all clean controlplane-config worker-config apply $(addprefix apply-controlplane-, $(CONTROLPLANE)) $(addprefix apply-worker-, $(WORKERS)) upgrade upgrade-controlplane upgrade-workers

default: all

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

controlplane-config: $(addprefix generated/controlplane/, $(CONTROLPLANE))

worker-config: $(addprefix generated/workers/, $(WORKERS))

all: controlplane-config worker-config

apply-controlplane-%: generated/controlplane/%.yaml
	@echo "Applying config on controlplane node $*"
	@talosctl apply-config -n $* --file generated/controlplane/$*.yaml

apply-worker-%: generated/workers/%.yaml
	@echo "Applying config on worker node $*"
	@talosctl apply-config -n $* --file generated/workers/$*.yaml

apply: $(addprefix apply-controlplane-, $(basename $(CONTROLPLANE))) $(addprefix apply-worker-, $(basename $(WORKERS)))

upgrade-controlplane: controlplane-config
	@echo "Upgrading controlplane nodes"
	@talosctl upgrade --image $(INSTALL_IMAGE) -n $(subst $(space),$(comma),$(basename $(CONTROLPLANE))) -p

upgrade-workers: worker-config
	@echo "Upgrading worker nodes"
	@talosctl upgrade --image $(INSTALL_IMAGE) -n $(subst $(space),$(comma),$(basename $(WORKERS)))

upgrade: upgrade-controlplane upgrade-workers

clean:
	@rm -rf generated
