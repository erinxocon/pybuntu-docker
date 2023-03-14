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

build_jammy: build_jammy_3.7.16 build_jammy_3.8.16 build_jammy_3.9.16 build_jammy_3.10.10 build_jammy_3.11.2 #build_jammy_3.12.0a6
	@echo 'All jammy based images built!'

build_focal: build_focal_3.7.16 build_focal_3.8.16 build_focal_3.9.16 build_focal_3.10.10 build_focal_3.11.2 #build_focal_3.12.0a6
	@echo 'All focal based images built!'

build_bionic: build_bionic_3.7.16 build_bionic_3.8.16 build_bionic_3.9.16 build_bionic_3.10.10 build_bionic_3.11.2 #build_bionic_3.12.0a6
	@echo 'All bionic images built'

build: build_bionic build_focal build_jammy
	@echo 'All images built!'

# Push
push_jammy:
	@echo 'Pushing jammy images'
	# @docker push jetblackpope/pybuntu:3.12.0a6-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.11.2-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.10-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.16-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.16-jammy-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.16-jammy-$(ARCH)

push_focal:
	@echo 'Pushing focal images'
	# @docker push jetblackpope/pybuntu:3.12.0a6-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.11.2-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.10-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.16-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.16-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.16-focal-$(ARCH)

push_bionic:
	@echo 'Pushing bionic images'
	# @docker push jetblackpope/pybuntu:3.12.0a6-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.11.2-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.10.10-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.16-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.16-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.16-bionic-$(ARCH)

push: push_focal push_bionic push_jammy
	@echo 'Pushing images up to dockerhub'

# Manifest
manifest_jammy_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-jammy --amend jetblackpope/pybuntu:$*-jammy-arm64 --amend jetblackpope/pybuntu:$*-jammy-x86_64

manifest_jammy: manifest_jammy_3.7.16 manifest_jammy_3.8.16 manifest_jammy_3.9.16 manifest_jammy_3.10.10 manifest_jammy_3.11.2 #manifest_jammy_3.12.0a6
	@echo 'Creating multi arch image for jammy'

manifest_bionic_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-bionic --amend jetblackpope/pybuntu:$*-bionic-arm64 --amend jetblackpope/pybuntu:$*-bionic-x86_64

manifest_bionic: manifest_bionic_3.7.16 manifest_bionic_3.8.16 manifest_bionic_3.9.16 manifest_bionic_3.10.10 manifest_bionic_3.11.2 #manifest_bionic_3.12.0a6
	@echo 'Creating multi arch image for bionic'

manifest_focal_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-focal --amend jetblackpope/pybuntu:$*-focal-arm64 --amend jetblackpope/pybuntu:$*-focal-x86_64

manifest_focal: manifest_focal_3.7.16 manifest_focal_3.8.16 manifest_focal_3.9.16 manifest_focal_3.10.10 manifest_focal_3.11.2 #manifest_focal_3.12.0a6
	@echo 'Creating multi arch manifest for focal'

manifest: manifest_focal manifest_bionic manifest_jammy
	@echo 'Creating all multiarch manifests'

push_manifest_jammy_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-jammy

push_manifest_jammy: push_manifest_jammy_3.7.16 push_manifest_jammy_3.8.16 push_manifest_jammy_3.9.16 push_manifest_jammy_3.10.10 push_manifest_jammy_3.11.2 #push_manifest_jammy_3.12.0a6
	@echo 'Pushing all multi-arch jammy images'

push_manifest_bionic_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-bionic

push_manifest_bionic: push_manifest_bionic_3.7.16 push_manifest_bionic_3.8.16 push_manifest_bionic_3.9.16 push_manifest_bionic_3.10.10 push_manifest_bionic_3.11.2 #push_manifest_bionic_3.12.0a6
	@echo 'Pushing all multi-arch bionic images'

push_manifest_focal_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-focal

push_manifest_focal: push_manifest_focal_3.7.16 push_manifest_focal_3.8.16 push_manifest_focal_3.9.16 push_manifest_focal_3.10.10 push_manifest_focal_3.11.2 #push_manifest_focal_3.12.0a6
	@echo 'Pushing all multi-arch focal images'

push_manifest: push_manifest_bionic push_manifest_focal push_jammy
	@echo 'Pushing all manifest files to dockerhub'

	@docker manifest create jetblackpope/pybuntu:latest --amend jetblackpope/pybuntu:3.11.2-jammy-arm64 --amend jetblackpope/pybuntu:3.11.2-jammy-x86_64

	@docker manifest create jetblackpope/pybuntu:3.11-jammy --amend jetblackpope/pybuntu:3.11.2-jammy-arm64 --amend jetblackpope/pybuntu:3.11.2-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.11-jammy

	@docker manifest create jetblackpope/pybuntu:3.10-jammy --amend jetblackpope/pybuntu:3.10.10-jammy-arm64 --amend jetblackpope/pybuntu:3.10.10-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-jammy

	@docker manifest create jetblackpope/pybuntu:3.9-jammy --amend jetblackpope/pybuntu:3.9.16-jammy-arm64 --amend jetblackpope/pybuntu:3.9.16-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-jammy

	@docker manifest create jetblackpope/pybuntu:3.8-jammy --amend jetblackpope/pybuntu:3.8.16-jammy-arm64 --amend jetblackpope/pybuntu:3.8.16-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-jammy

	@docker manifest create jetblackpope/pybuntu:3.7-jammy --amend jetblackpope/pybuntu:3.7.16-jammy-arm64 --amend jetblackpope/pybuntu:3.7.16-jammy-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-jammy

	@docker manifest create jetblackpope/pybuntu:3.11-focal --amend jetblackpope/pybuntu:3.11.2-focal-arm64 --amend jetblackpope/pybuntu:3.11.2-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.11-focal

	@docker manifest create jetblackpope/pybuntu:3.10-focal --amend jetblackpope/pybuntu:3.10.10-focal-arm64 --amend jetblackpope/pybuntu:3.10.10-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-focal

	@docker manifest create jetblackpope/pybuntu:3.9-focal --amend jetblackpope/pybuntu:3.9.16-focal-arm64 --amend jetblackpope/pybuntu:3.9.16-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-focal

	@docker manifest create jetblackpope/pybuntu:3.8-focal --amend jetblackpope/pybuntu:3.8.16-focal-arm64 --amend jetblackpope/pybuntu:3.8.16-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-focal

	@docker manifest create jetblackpope/pybuntu:3.7-focal --amend jetblackpope/pybuntu:3.7.16-focal-arm64 --amend jetblackpope/pybuntu:3.7.16-focal-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-focal

	@docker manifest create jetblackpope/pybuntu:3.11-bionic --amend jetblackpope/pybuntu:3.11.2-bionic-arm64 --amend jetblackpope/pybuntu:3.11.2-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.11-bionic

	@docker manifest create jetblackpope/pybuntu:3.10-bionic --amend jetblackpope/pybuntu:3.10.10-bionic-arm64 --amend jetblackpope/pybuntu:3.10.10-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.10-bionic

	@docker manifest create jetblackpope/pybuntu:3.9-bionic --amend jetblackpope/pybuntu:3.9.16-bionic-arm64 --amend jetblackpope/pybuntu:3.9.16-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.9-bionic

	@docker manifest create jetblackpope/pybuntu:3.8-bionic --amend jetblackpope/pybuntu:3.8.16-bionic-arm64 --amend jetblackpope/pybuntu:3.8.16-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.8-bionic

	@docker manifest create jetblackpope/pybuntu:3.7-bionic --amend jetblackpope/pybuntu:3.7.16-bionic-arm64 --amend jetblackpope/pybuntu:3.7.16-bionic-x86_64
	@docker manifest push jetblackpope/pybuntu:3.7-bionic
