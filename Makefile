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

build_focal_%: 
	@echo 'Building $* on Ubuntu 20.04 for $(ARCH)'
	@docker build --rm -f "out/$*/focal/Dockerfile" -t pybuntu:$*-20.04-$(ARCH) -t jetblackpope/pybuntu:$*-focal-$(ARCH) out/$*/focal

build_bionic_%:
	@echo 'Building $* on Ubuntu 18.04'
	docker build --rm -f "out/$*/bionic/Dockerfile" -t pybuntu:$*-18.04-$(ARCH) -t jetblackpope/pybuntu:$*-bionic-$(ARCH) out/$*/bionic

build_focal: build_focal_3.6.14 build_focal_3.7.11 build_focal_3.8.11 build_focal_3.9.6 build_focal_3.10.0rc1
	@echo 'All focal based images built!'

build_bionic: build_bionic_3.6.14 build_bionic_3.7.11 build_bionic_3.8.11 build_bionic_3.9.6 build_bionic_3.10.0rc1
	@echo 'All bionic images built'

build: build_bionic build_focal
	@echo 'All images built!'

# Push

push_focal:
	@echo 'Pushing focal images'
	@docker push jetblackpope/pybuntu:3.10.0rc1-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.6-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.11-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.11-focal-$(ARCH)
	@docker push jetblackpope/pybuntu:3.6.14-focal-$(ARCH)

push_bionic:
	@echo 'Pushing bionic images'
	@docker push jetblackpope/pybuntu:3.10.0rc1-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.9.6-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.8.11-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.7.11-bionic-$(ARCH)
	@docker push jetblackpope/pybuntu:3.6.14-bionic-$(ARCH)

push: push_focal push_bionic
	@echo 'Pushing images up to dockerhub'

# Manifest

manifest_bionic_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-bionic --amend jetblackpope/pybuntu:$*-bionic-arm64 --amend jetblackpope/pybuntu:$*-bionic-amd64

manifest_bionic: manifest_bionic_3.6.14 manifest_bionic_3.7.11 manifest_bionic_3.8.11 manifest_bionic_3.9.6 manifest_bionic_3.10.0rc1
	@echo 'Creating multi arch image'

manifest_focal_%:
	@echo 'Creating multi arch manifest for $*'
	@docker manifest create jetblackpope/pybuntu:$*-focal --amend jetblackpope/pybuntu:$*-focal-arm64 --amend jetblackpope/pybuntu:$*-focal-amd64

manifest_focal: manifest_focal_3.6.14 manifest_focal_3.7.11 manifest_focal_3.8.11 manifest_focal_3.9.6 manifest_focal_3.10.0rc1
	@echo 'Creating multi arch image'

push_manifest_bionic_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-bionic

push_manifest_bionic: push_manifest_bionic_3.6.14 push_manifest_bionic_3.7.11 push_manifest_bionic_3.8.11 push_manifest_bionic_3.9.6 push_manifest_bionic_3.10.0rc1
	@echo 'Pushing all multi-arch bionic images'

push_manifest_focal_%:
	@echo 'Pushing multi-arch image'
	@docker manifest push jetblackpope/pybuntu:$*-focal

push_manifest_focal: push_manifest_focal_3.6.14 push_manifest_focal_3.7.11 push_manifest_focal_3.8.11 push_manifest_focal_3.9.6 push_manifest_focal_3.10.0rc1
	@echo 'Pushing all multi-arch focal images'

# Pull

pull_focal_%:
	docker pull jetblackpope/pybuntu:$*-focal

pull_focal: pull_focal_3.6.14 pull_focal_3.7.11 pull_focal_3.8.11 pull_focal_3.9.6 pull_focal_3.10.0rc1
	@echo 'Pulling focal'

pull_bionic_%:
	@docker pull jetblackpope/pybuntu:$*-focal

pull_bionic: pull_focal_3.6.14 pull_focal_3.7.11 pull_focal_3.8.11 pull_focal_3.9.6 pull_focal_3.10.0rc1
	@echo 'Pulling bionic'

pull: pull_bionic pull_focal
	@echo 'Pulling all images'
