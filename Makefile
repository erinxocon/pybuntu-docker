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

build_jammy: build_jammy_3.7.17 build_jammy_3.8.18 build_jammy_3.9.18 build_jammy_3.10.12 build_jammy_3.11.5 #build_jammy_3.12.0rc2
	@echo 'All jammy based images built!'

build_focal: build_focal_3.7.17 build_focal_3.8.18 build_focal_3.9.18 build_focal_3.10.12 build_focal_3.11.5 #build_focal_3.12.0rc2
	@echo 'All focal based images built!'

build_bionic: build_bionic_3.7.17 build_bionic_3.8.18 build_bionic_3.9.18 build_bionic_3.10.12 build_bionic_3.11.5 #build_bionic_3.12.0rc2
	@echo 'All bionic images built'

build: build_bionic build_focal build_jammy
	@echo 'All images built!'

# Push
push_jammy:
	@echo 'Pushing jammy images'
	# @docker push jetblackpope/pybuntu:3.12.0rc2-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.11.5-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.12-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.18-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.18-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.17-jammy-$(ARCH)

push_focal:
	@echo 'Pushing focal images'
	# @docker push jetblackpope/pybuntu:3.12.0rc2-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.11.5-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.12-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.18-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.18-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.17-focal-$(ARCH)

push_bionic:
	@echo 'Pushing bionic images'
	# @docker push jetblackpope/pybuntu:3.12.0rc2-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.11.5-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.12-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.18-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.18-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.17-bionic-$(ARCH)

push: push_focal push_bionic push_jammy
	@echo 'Pushing images up to dockerhub'

# Manifest
manifest_jammy_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-jammy --amend jetblackpope/pybuntu:$*-jammy-arm64 --amend jetblackpope/pybuntu:$*-jammy-x86_64

manifest_jammy: manifest_jammy_3.7.17 manifest_jammy_3.8.18 manifest_jammy_3.9.18 manifest_jammy_3.10.12 manifest_jammy_3.11.5 #manifest_jammy_3.12.0rc2
	@echo 'Creating multi arch image for jammy'

manifest_bionic_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-bionic --amend jetblackpope/pybuntu:$*-bionic-arm64 --amend jetblackpope/pybuntu:$*-bionic-x86_64

manifest_bionic: manifest_bionic_3.7.17 manifest_bionic_3.8.18 manifest_bionic_3.9.18 manifest_bionic_3.10.12 manifest_bionic_3.11.5 #manifest_bionic_3.12.0rc2
	@echo 'Creating multi arch image for bionic'

manifest_focal_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-focal --amend jetblackpope/pybuntu:$*-focal-arm64 --amend jetblackpope/pybuntu:$*-focal-x86_64

manifest_focal: manifest_focal_3.7.17 manifest_focal_3.8.18 manifest_focal_3.9.18 manifest_focal_3.10.12 manifest_focal_3.11.5 #manifest_focal_3.12.0rc2
	@echo 'Creating multi arch manifest for focal'

manifest: manifest_focal manifest_bionic manifest_jammy
	@echo 'Creating all multiarch manifests'

push_manifest_jammy_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-jammy

push_manifest_jammy: push_manifest_jammy_3.7.17 push_manifest_jammy_3.8.18 push_manifest_jammy_3.9.18 push_manifest_jammy_3.10.12 push_manifest_jammy_3.11.5 #push_manifest_jammy_3.12.0rc2
	@echo 'Pushing all multi-arch jammy images'

push_manifest_bionic_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-bionic

push_manifest_bionic: push_manifest_bionic_3.7.17 push_manifest_bionic_3.8.18 push_manifest_bionic_3.9.18 push_manifest_bionic_3.10.12 push_manifest_bionic_3.11.5 #push_manifest_bionic_3.12.0rc2
	@echo 'Pushing all multi-arch bionic images'

push_manifest_focal_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-focal

push_manifest_focal: push_manifest_focal_3.7.17 push_manifest_focal_3.8.18 push_manifest_focal_3.9.18 push_manifest_focal_3.10.12 push_manifest_focal_3.11.5 #push_manifest_focal_3.12.0rc2
	@echo 'Pushing all multi-arch focal images'

push_manifest: push_manifest_bionic push_manifest_focal push_jammy
	@echo 'Pushing all manifest files to dockerhub'

	@docker manifest create jetblackpope/pybuntu:latest --amend jetblackpope/pybuntu:3.11.5-jammy-arm64 --amend jetblackpope/pybuntu:3.11.5-jammy-x86_64

	@docker manifest create jetblackpope/pybuntu:3.11-jammy --amend jetblackpope/pybuntu:3.11.5-jammy-arm64 --amend jetblackpope/pybuntu:3.11.5-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.11-jammy

	@docker manifest create jetblackpope/pybuntu:3.10-jammy --amend jetblackpope/pybuntu:3.10.12-jammy-arm64 --amend jetblackpope/pybuntu:3.10.12-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-jammy

	@docker manifest create jetblackpope/pybuntu:3.9-jammy --amend jetblackpope/pybuntu:3.9.18-jammy-arm64 --amend jetblackpope/pybuntu:3.9.18-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-jammy

	@docker manifest create jetblackpope/pybuntu:3.8-jammy --amend jetblackpope/pybuntu:3.8.18-jammy-arm64 --amend jetblackpope/pybuntu:3.8.18-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-jammy

	@docker manifest create jetblackpope/pybuntu:3.7-jammy --amend jetblackpope/pybuntu:3.7.17-jammy-arm64 --amend jetblackpope/pybuntu:3.7.17-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-jammy

	@docker manifest create jetblackpope/pybuntu:3.11-focal --amend jetblackpope/pybuntu:3.11.5-focal-arm64 --amend jetblackpope/pybuntu:3.11.5-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.11-focal

	@docker manifest create jetblackpope/pybuntu:3.10-focal --amend jetblackpope/pybuntu:3.10.12-focal-arm64 --amend jetblackpope/pybuntu:3.10.12-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-focal

	@docker manifest create jetblackpope/pybuntu:3.9-focal --amend jetblackpope/pybuntu:3.9.18-focal-arm64 --amend jetblackpope/pybuntu:3.9.18-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-focal

	@docker manifest create jetblackpope/pybuntu:3.8-focal --amend jetblackpope/pybuntu:3.8.18-focal-arm64 --amend jetblackpope/pybuntu:3.8.18-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-focal

	@docker manifest create jetblackpope/pybuntu:3.7-focal --amend jetblackpope/pybuntu:3.7.17-focal-arm64 --amend jetblackpope/pybuntu:3.7.17-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-focal

	@docker manifest create jetblackpope/pybuntu:3.11-bionic --amend jetblackpope/pybuntu:3.11.5-bionic-arm64 --amend jetblackpope/pybuntu:3.11.5-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.11-bionic

	@docker manifest create jetblackpope/pybuntu:3.10-bionic --amend jetblackpope/pybuntu:3.10.12-bionic-arm64 --amend jetblackpope/pybuntu:3.10.12-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-bionic

	@docker manifest create jetblackpope/pybuntu:3.9-bionic --amend jetblackpope/pybuntu:3.9.18-bionic-arm64 --amend jetblackpope/pybuntu:3.9.18-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-bionic

	@docker manifest create jetblackpope/pybuntu:3.8-bionic --amend jetblackpope/pybuntu:3.8.18-bionic-arm64 --amend jetblackpope/pybuntu:3.8.18-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-bionic

	@docker manifest create jetblackpope/pybuntu:3.7-bionic --amend jetblackpope/pybuntu:3.7.17-bionic-arm64 --amend jetblackpope/pybuntu:3.7.17-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-bionic
