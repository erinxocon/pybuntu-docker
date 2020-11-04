.PHONY: help clean generate build_focal build_dev build_bionic build

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
	@echo '	build_dev			Build all dev images'
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

build_focal_%: 
	@echo 'Building $* on Ubuntu 20.04'
	@docker build --rm -f "out/$*/focal/Dockerfile" -t pybuntu:$*-20.04 -t jetblackpope/pybuntu:$*-focal out/$*/focal

build_bionic_%:
	@echo 'Building $* on Ubuntu 18.04'
	docker build --rm -f "out/$*/bionic/Dockerfile" -t pybuntu:$*-18.04 -t jetblackpope/pybuntu:$*-bionic out/$*/bionic

build_focal: build_focal_3.5.10 build_focal_3.6.12 build_focal_3.7.9 build_focal_3.8.6 build_focal_3.9.0 build_focal_3.10.0a2
	@echo 'All focal based images built!'

build_bionic: build_bionic_3.5.10 build_bionic_3.6.12 build_bionic_3.7.9 build_bionic_3.8.6 build_bionic_3.9.0 build_bionic_3.10.0a2
	@echo 'All bionic images built'

build: build_bionic build_focal
	@echo 'All images built!'

push_focal:
	@echo 'Pushing focal images'
	@docker push jetblackpope/pybuntu:3.10.0a2-focal
	@docker push jetblackpope/pybuntu:3.9.0-focal
	@docker push jetblackpope/pybuntu:3.8.6-focal
	@docker push jetblackpope/pybuntu:3.7.9-focal
	@docker push jetblackpope/pybuntu:3.6.12-focal
	@docker push jetblackpope/pybuntu:3.5.10-focal

	@docker tag jetblackpope/pybuntu:3.9.0-focal jetblackpope/pybuntu:3-focal
	@docker push jetblackpope/pybuntu:3-focal

	@docker tag jetblackpope/pybuntu:3.10.0a2-focal jetblackpope/pybuntu:3.10-focal
	@docker push jetblackpope/pybuntu:3.10-focal

	@docker tag jetblackpope/pybuntu:3.9.0-focal jetblackpope/pybuntu:3.9-focal
	@docker push jetblackpope/pybuntu:3.9-focal

	@docker tag jetblackpope/pybuntu:3.8.6-focal jetblackpope/pybuntu:3.8-focal
	@docker push jetblackpope/pybuntu:3.8-focal

	@docker tag jetblackpope/pybuntu:3.7.9-focal jetblackpope/pybuntu:3.7-focal
	@docker push jetblackpope/pybuntu:3.7-focal

	@docker tag jetblackpope/pybuntu:3.6.12-focal jetblackpope/pybuntu:3.6-focal
	@docker push jetblackpope/pybuntu:3.6-focal

	@docker tag jetblackpope/pybuntu:3.5.10-focal jetblackpope/pybuntu:3.5-focal
	@docker push jetblackpope/pybuntu:3.5-focal

push_bionic:
	@echo 'Pushing bionic images'
	@docker push jetblackpope/pybuntu:3.10.0a2-bionic
	@docker push jetblackpope/pybuntu:3.9.0-bionic
	@docker push jetblackpope/pybuntu:3.8.6-bionic
	@docker push jetblackpope/pybuntu:3.7.9-bionic
	@docker push jetblackpope/pybuntu:3.6.12-bionic
	@docker push jetblackpope/pybuntu:3.5.10-bionic

	@docker tag jetblackpope/pybuntu:3.9.0-bionic jetblackpope/pybuntu:latest
	@docker push jetblackpope/pybuntu:latest

	@docker tag jetblackpope/pybuntu:3.9.0-bionic jetblackpope/pybuntu:3
	@docker push jetblackpope/pybuntu:3

	@docker tag jetblackpope/pybuntu:3.10.0a2-focal jetblackpope/pybuntu:3.10-focal
	@docker push jetblackpope/pybuntu:3.10-focal

	@docker tag jetblackpope/pybuntu:3.9.0-focal jetblackpope/pybuntu:3.9-focal
	@docker push jetblackpope/pybuntu:3.9-focal

	@docker tag jetblackpope/pybuntu:3.8.6-bionic jetblackpope/pybuntu:3.8-bionic
	@docker push jetblackpope/pybuntu:3.8-bionic

	@docker tag jetblackpope/pybuntu:3.7.9-bionic jetblackpope/pybuntu:3.7-bionic
	@docker push jetblackpope/pybuntu:3.7-bionic

	@docker tag jetblackpope/pybuntu:3.6.12-bionic jetblackpope/pybuntu:3.6-bionic
	@docker push jetblackpope/pybuntu:3.6-bionic

	@docker tag jetblackpope/pybuntu:3.5.10-bionic jetblackpope/pybuntu:3.5-bionic
	@docker push jetblackpope/pybuntu:3.5-bionic

push: push_focal push_bionic
	@echo 'Pushing images up to dockerhub'
