.PHONY: help clean generate build_disco build_dev build_bionic build

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
	@echo '	build_disco			Build all disco based images'
	@echo '	build_dev			Build all dev images'
	@echo '	build_bionic			Build all bionic based images'
	@echo '	build_disco_[version]		Build specific version of python against ubutnu 19.04'
	@echo '	build_dev_[version]		Build specific version of python against ubuntu 18.04, keeping build dependecies'
	@echo '	build_bionic_[version]		Build specific version of python against ubuntu 18.04'
	@echo
	@echo 'Upload:'
	@echo '	push				Push all docker images up to dockerhub.'

clean:
	rm -rf 2.7.16 2.7.17rc1 3.5.7 3.5.8rc1 3.6.9 3.7.4 3.7.5rc1 3.8.0rc1

generate:
	@python generate_dockerfiles.py
	@echo 'All Dockerfiles Generated!'

build_disco_%: 
	@echo 'Building $* on Ubuntu 19.04'
	@ docker build --rm -f "$*/Dockerfile.1904" -t pybuntu:$*-19.04 -t jetblackpope/pybuntu:$*-disco $*

build_dev_%:
	@echo 'Building $* dev image on Ubuntu 18.04'
	@docker build --rm -f "$*/Dockerfile.1804.dev" -t pybuntu:$*-18.04-dev -t jetblackpope/pybuntu:$*-bionic-dev $*

build_bionic_%:
	@echo 'Building $* on Ubuntu 18.04'
	@docker build --rm -f "$*/Dockerfile.1804" -t pybuntu:$*-18.04 -t jetblackpope/pybuntu:$*-bionic $*

build_disco: build_disco_2.7.16 build_disco_2.7.17rc1 build_disco_3.5.7 build_disco_3.5.8rc1 build_disco_3.6.9 build_disco_3.7.4 build_disco_3.7.5rc1 build_disco_3.8.0rc1
	@echo 'All disco based images built!'

build_dev: build_dev_2.7.16 build_dev_3.5.7  build_dev_3.6.9 build_dev_3.7.4
	@echo 'All dev images built!'

build_bionic: build_bionic_2.7.16 build_bionic_2.7.17rc1 build_bionic_3.5.7 build_bionic_3.5.8rc1 build_bionic_3.6.9 build_bionic_3.7.4 build_bionic_3.7.5rc1 build_bionic_3.8.0rc1
	@echo 'All bionic images built'

build: build_bionic build_dev build_disco
	@echo 'All images built!'

push:
	@echo 'Pushing images up to dockerhub'
	@docker push jetblackpope/pybuntu:3.8.0rc1-bionic
	@docker push jetblackpope/pybuntu:3.7.5rc1-bionic
	@docker push jetblackpope/pybuntu:3.7.4-bionic
	@docker push jetblackpope/pybuntu:3.6.9-bionic
	@docker push jetblackpope/pybuntu:3.5.8rc1-bionic
	@docker push jetblackpope/pybuntu:3.5.7-bionic
	@docker push jetblackpope/pybuntu:2.7.17rc1-bionic
	@docker push jetblackpope/pybuntu:2.7.16-bionic
	@docker push jetblackpope/pybuntu:3.7.4-bionic-dev
	@docker push jetblackpope/pybuntu:3.6.9-bionic-dev
	@docker push jetblackpope/pybuntu:3.5.7-bionic-dev
	@docker push jetblackpope/pybuntu:2.7.16-bionic-dev
	@docker push jetblackpope/pybuntu:3.8.0rc1-disco
	@docker push jetblackpope/pybuntu:3.7.5rc1-disco
	@docker push jetblackpope/pybuntu:3.7.4-disco
	@docker push jetblackpope/pybuntu:3.6.9-disco
	@docker push jetblackpope/pybuntu:3.5.8rc1-disco
	@docker push jetblackpope/pybuntu:3.5.7-disco
	@docker push jetblackpope/pybuntu:2.7.17rc1-disco
	@docker push jetblackpope/pybuntu:2.7.16-disco

	@docker tag jetblackpope/pybuntu:3.7.4-bionic jetblackpope/pybuntu:latest
	@docker push jetblackpope/pybuntu:latest
	@docker tag jetblackpope/pybuntu:3.7.4-bionic jetblackpope/pybuntu:3.7
	@docker push jetblackpope/pybuntu:3.7
	@docker tag jetblackpope/pybuntu:3.7.4-bionic jetblackpope/pybuntu:3
	@docker push jetblackpope/pybuntu:3

	@docker tag jetblackpope/pybuntu:3.6.9-bionic jetblackpope/pybuntu:3.6
	@docker push jetblackpope/pybuntu:3.6

	@docker tag jetblackpope/pybuntu:3.5.7-bionic jetblackpope/pybuntu:3.5
	@docker push jetblackpope/pybuntu:3.5

	@docker tag jetblackpope/pybuntu:2.7.16-bionic jetblackpope/pybuntu:2
	@docker push jetblackpope/pybuntu:2

	@docker tag jetblackpope/pybuntu:2.7.16-bionic jetblackpope/pybuntu:2.7
	@docker push jetblackpope/pybuntu:2.7