.PHONY: help clean generate build_focal build_dev build_bionic build

ARCH := $(shell uname -m)

help: 
	@echo 'usage: make [target]'
	@echo
	@echo 'Help:'
	@echo '	help				This message'
	@echo
	@echo 'Generate:'
	@echo '	generate			Generate all dockerfiles'
	@echo
	@echo 'Build:'
	@echo '	build				Build all docker images'
	@echo '	build_focal			Build all focal based images'
	@echo '	build_bionic			Build all bionic based images'
	@echo '	build_focal_[version]		Build specific version of python against ubutnu 20.04'
	@echo '	build_bionic_[version]		Build specific version of python against ubuntu 18.04'
	@echo
	@echo 'Upload:'
	@echo '	push				Push all docker images up to dockerhub.'

clean:
	rm -rf out

generate:
	@python generate.py
	@echo 'All Dockerfiles Generated!'

# Build
build_jammy_%:
	@echo 'Building $* on Ubuntu 22.04'
	docker build --rm -f "out/$*/jammy/Dockerfile" -t pybuntu:$*-22.04-$(ARCH) -t jetblackpope/pybuntu:$*-jammy-$(ARCH) out/$*/jammy

build_focal_%: 
	@echo 'Building $* on Ubuntu 20.04 for $(ARCH)'
	@docker build --rm -f "out/$*/focal/Dockerfile" -t pybuntu:$*-20.04-$(ARCH) -t jetblackpope/pybuntu:$*-focal-$(ARCH) out/$*/focal

build_bionic_%:
	@echo 'Building $* on Ubuntu 18.04'
	docker build --rm -f "out/$*/bionic/Dockerfile" -t pybuntu:$*-18.04-$(ARCH) -t jetblackpope/pybuntu:$*-bionic-$(ARCH) out/$*/bionic

build_jammy: build_jammy_3.7.13 build_jammy_3.8.13 build_jammy_3.9.13 build_jammy_3.10.6 build_jammy_3.11.0rc1
	@echo 'All jammy based images built!'

build_focal: build_focal_3.7.13 build_focal_3.8.13 build_focal_3.9.13 build_focal_3.10.6 build_focal_3.11.0rc1
	@echo 'All focal based images built!'

build_bionic: build_bionic_3.7.13 build_bionic_3.8.13 build_bionic_3.9.13 build_bionic_3.10.6 build_bionic_3.11.0rc1
	@echo 'All bionic images built'

build: build_bionic build_focal build_jammy
	@echo 'All images built!'

# Push
push_jammy:
	@echo 'Pushing jammy images'
	@docker push jetblackpope/pybuntu:3.11.0rc1-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.6-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.13-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.13-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.13-jammy-$(ARCH)

push_focal:
	@echo 'Pushing focal images'
	@docker push jetblackpope/pybuntu:3.11.0rc1-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.6-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.13-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.13-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.13-focal-$(ARCH)

push_bionic:
	@echo 'Pushing bionic images'
	@docker push jetblackpope/pybuntu:3.11.0rc1-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.6-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.13-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.13-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.13-bionic-$(ARCH)

push: push_focal push_bionic push_jammy
	@echo 'Pushing images up to dockerhub'

# Manifest
manifest_jammy_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-jammy --amend jetblackpope/pybuntu:$*-jammy-arm64 --amend jetblackpope/pybuntu:$*-jammy-x86_64

manifest_jammy: manifest_jammy_3.7.13 manifest_jammy_3.8.13 manifest_jammy_3.9.13 manifest_jammy_3.10.6 manifest_jammy_3.11.0rc1
	@echo 'Creating multi arch image for jammy'

manifest_bionic_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-bionic --amend jetblackpope/pybuntu:$*-bionic-arm64 --amend jetblackpope/pybuntu:$*-bionic-x86_64

manifest_bionic: manifest_bionic_3.7.13 manifest_bionic_3.8.13 manifest_bionic_3.9.13 manifest_bionic_3.10.6 manifest_bionic_3.11.0rc1
	@echo 'Creating multi arch image for bionic'

manifest_focal_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-focal --amend jetblackpope/pybuntu:$*-focal-arm64 --amend jetblackpope/pybuntu:$*-focal-x86_64

manifest_focal: manifest_focal_3.7.13 manifest_focal_3.8.13 manifest_focal_3.9.13 manifest_focal_3.10.6 manifest_focal_3.11.0rc1
	@echo 'Creating multi arch manifest for focal'

manifest: manifest_focal manifest_bionic manifest_jammy
	@echo 'Creating all multiarch manifests'

push_manifest_jammy_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-jammy

push_manifest_jammy: push_manifest_jammy_3.7.13 push_manifest_jammy_3.8.13 push_manifest_jammy_3.9.13 push_manifest_jammy_3.10.6 push_manifest_jammy_3.11.0rc1
	@echo 'Pushing all multi-arch jammy images'

push_manifest_bionic_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-bionic

push_manifest_bionic: push_manifest_bionic_3.7.13 push_manifest_bionic_3.8.13 push_manifest_bionic_3.9.13 push_manifest_bionic_3.10.6 push_manifest_bionic_3.11.0rc1
	@echo 'Pushing all multi-arch bionic images'

push_manifest_focal_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-focal

push_manifest_focal: push_manifest_focal_3.7.13 push_manifest_focal_3.8.13 push_manifest_focal_3.9.13 push_manifest_focal_3.10.6 push_manifest_focal_3.11.0rc1
	@echo 'Pushing all multi-arch focal images'

push_manifest: push_manifest_bionic push_manifest_focal push_jammy
	@echo 'Pushing all manifest files to dockerhub'

	@docker manifest create jetblackpope/pybuntu:latest --amend jetblackpope/pybuntu:3.10.6-focal-arm64 --amend jetblackpope/pybuntu:3.10.6-focal-x86_64

	@docker manifest create jetblackpope/pybuntu:3.10-jammy --amend jetblackpope/pybuntu:3.10.6-jammy-arm64 --amend jetblackpope/pybuntu:3.10.6-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-jammy

	@docker manifest create jetblackpope/pybuntu:3.9-jammy --amend jetblackpope/pybuntu:3.9.13-jammy-arm64 --amend jetblackpope/pybuntu:3.9.13-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-jammy

	@docker manifest create jetblackpope/pybuntu:3.8-jammy --amend jetblackpope/pybuntu:3.8.13-jammy-arm64 --amend jetblackpope/pybuntu:3.8.13-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-jammy

	@docker manifest create jetblackpope/pybuntu:3.7-jammy --amend jetblackpope/pybuntu:3.7.13-jammy-arm64 --amend jetblackpope/pybuntu:3.7.13-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-jammy

	@docker manifest create jetblackpope/pybuntu:3.10-focal --amend jetblackpope/pybuntu:3.10.6-focal-arm64 --amend jetblackpope/pybuntu:3.10.6-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-focal

	@docker manifest create jetblackpope/pybuntu:3.9-focal --amend jetblackpope/pybuntu:3.9.13-focal-arm64 --amend jetblackpope/pybuntu:3.9.13-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-focal

	@docker manifest create jetblackpope/pybuntu:3.8-focal --amend jetblackpope/pybuntu:3.8.13-focal-arm64 --amend jetblackpope/pybuntu:3.8.13-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-focal

	@docker manifest create jetblackpope/pybuntu:3.7-focal --amend jetblackpope/pybuntu:3.7.13-focal-arm64 --amend jetblackpope/pybuntu:3.7.13-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-focal

	@docker manifest create jetblackpope/pybuntu:3.10-bionic --amend jetblackpope/pybuntu:3.10.6-bionic-arm64 --amend jetblackpope/pybuntu:3.10.6-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-bionic

	@docker manifest create jetblackpope/pybuntu:3.9-bionic --amend jetblackpope/pybuntu:3.9.13-bionic-arm64 --amend jetblackpope/pybuntu:3.9.13-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-bionic

	@docker manifest create jetblackpope/pybuntu:3.8-bionic --amend jetblackpope/pybuntu:3.8.13-bionic-arm64 --amend jetblackpope/pybuntu:3.8.13-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-bionic

	@docker manifest create jetblackpope/pybuntu:3.7-bionic --amend jetblackpope/pybuntu:3.7.13-bionic-arm64 --amend jetblackpope/pybuntu:3.7.13-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-bionic
