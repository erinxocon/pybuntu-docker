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

generate:
	@python generate_dockerfiles.py
	@echo 'All Dockerfiles Generated!'

build_disco_%: 
	@echo 'Building $* on Ubuntu 19.04'
	@ docker build --rm -f "$*/Dockerfile.1904" -t pybuntu:$*-19.04 $*

build_dev_%:
	@echo 'Building $* dev image on Ubuntu 18.04'
	@docker build --rm -f "$*/Dockerfile.1804.dev" -t pybuntu:$*-18.04-dev $*-dev

build_bionic_%:
	@echo 'Building $* on Ubuntu 18.04'
	@docker build --rm -f "$*/Dockerfile.1804" -t pybuntu:$*-18.04 $* 

build_disco: build_2.7.16_disco build_3.5.7_disco build_3.5.8rc1_disco build_3.6.9_disco build_3.7.4_disco build_3.7.5rc1_disco build_3.8.0rc1_disco
	@echo 'All disco based images built!'

build_dev: build_2.7.16_dev build_3.5.7_dev  build_3.6.9_dev build_3.7.4_dev
	@echo 'All dev images built!'

build_bionic: build_2.7.16_bionic build_3.5.7_bionic build.3.5.8rc1_bionic build_3.6.9_bionic build_3.7.4_bionic build_3.7.5rc1_bionic build_3.8.0rc1_bionic
	@echo 'All bionic images built'

build: build_bionic build_dev build_disco
	@echo 'All images built!'