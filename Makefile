all: gcloud \
      linkerd \
      kubectl \
      terraform

###########################
#         Versions
###########################
TF_VERSION=v0.14.6
KCTL_VERSION=v1.19.0
LINKERD_VERSION=stable-2.9.4

gcloud: 
ifeq ($(shell command -v gcloud 2> /dev/null),)
	curl https://sdk.cloud.google.com | bash
endif

terraform: 
	cd sources/github.com/hashicorp/terraform \
		&& git clean -fdx \
		&& git reset --hard \
		&& git checkout main \
		&& git pull \
		&& git checkout $(TF_VERSION) \
		&& go mod vendor \
		&& mkdir bin \
		&& go build -o ./bin ./... \
		&& sudo cp bin/terraform /usr/local/bin/
 
kubectl:
	curl -Lo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/$(KCTL_VERSION)/bin/linux/amd64/kubectl
	chmod +x /tmp/kubectl
	sudo mv /tmp/kubectl /usr/local/bin/kubectl

linkerd:
	cd sources/github.com/linkerd/linkerd2 && \
		git clean -f -d && \
		git reset --hard && \
		git checkout main && \
		git pull && \
		git checkout $(LINKERD_VERSION) && \
		go build -o linkerd cli/main.go && \
		sudo cp ./linkerd /usr/local/bin/linkerd

