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
	@echo '	build_bionic_[version]		Build specific version of python against ubuntu 18.04'
	@echo
	@echo 'Upload:'
	@echo '	push				Push all docker images up to dockerhub.'

clean:
	rm -rf out

generate:
	@python generate.py
	@echo 'All Dockerfiles Generated!'

build_disco_%: 
	@echo 'Building $* on Ubuntu 19.04'
	@docker build --rm -f "out/$*/disco/Dockerfile" -t pybuntu:$*-19.04 -t jetblackpope/pybuntu:$*-disco out/$*/disco

build_bionic_%:
	@echo 'Building $* on Ubuntu 18.04'
	docker build --rm -f "out/$*/bionic/Dockerfile" -t pybuntu:$*-18.04 -t jetblackpope/pybuntu:$*-bionic out/$*/bionic

build_disco: build_disco_2.7.17 build_disco_3.5.9 build_disco_3.6.10 build_disco_3.7.6 build_disco_3.8.1 build_disco_3.9.0a3 build_disco_3.8.2rc2
	@echo 'All disco based images built!'

build_bionic: build_bionic_2.7.17 build_bionic_3.5.9 build_bionic_3.6.10 build_bionic_3.7.6 build_bionic_3.8.1 build_bionic_3.9.0a3 build_bionic_3.8.2rc2
	@echo 'All bionic images built'

build: build_bionic build_disco
	@echo 'All images built!'

push_disco:
	@echo 'Pushing disco images'
	@docker push jetblackpope/pybuntu:3.8.1-disco
	@docker push jetblackpope/pybuntu:3.7.6-disco
	@docker push jetblackpope/pybuntu:3.6.10-disco
	@docker push jetblackpope/pybuntu:3.5.9-disco
	@docker push jetblackpope/pybuntu:2.7.17-disco

	@docker push jetblackpope/pybuntu:3.9.0a3-disco
	@docker push jetblackpope/pybuntu:3.8.2rc2-disco


	@docker tag jetblackpope/pybuntu:3.8.1-disco jetblackpope/pybuntu:3-disco
	@docker push jetblackpope/pybuntu:3-disco

	@docker tag jetblackpope/pybuntu:3.9.0a3-disco jetblackpope/pybuntu:3.9-disco
	@docker push jetblackpope/pybuntu:3.9-disco

	@docker tag jetblackpope/pybuntu:3.8.1-disco jetblackpope/pybuntu:3.8-disco
	@docker push jetblackpope/pybuntu:3.8-disco

	@docker tag jetblackpope/pybuntu:3.7.6-disco jetblackpope/pybuntu:3.7-disco
	@docker push jetblackpope/pybuntu:3.7-disco

	@docker tag jetblackpope/pybuntu:3.6.10-disco jetblackpope/pybuntu:3.6-disco
	@docker push jetblackpope/pybuntu:3.6-disco

	@docker tag jetblackpope/pybuntu:3.5.9-disco jetblackpope/pybuntu:3.5-disco
	@docker push jetblackpope/pybuntu:3.5-disco

	@docker tag jetblackpope/pybuntu:2.7.17-disco jetblackpope/pybuntu:2-disco
	@docker push jetblackpope/pybuntu:2-disco

	@docker tag jetblackpope/pybuntu:2.7.17-disco jetblackpope/pybuntu:2.7-disco
	@docker push jetblackpope/pybuntu:2.7-disco

push_bionic:
	@echo 'Pushing bionic images'
	@docker push jetblackpope/pybuntu:3.8.1-bionic
	@docker push jetblackpope/pybuntu:3.7.6-bionic
	@docker push jetblackpope/pybuntu:3.6.10-bionic
	@docker push jetblackpope/pybuntu:3.5.9-bionic
	@docker push jetblackpope/pybuntu:2.7.17-bionic

	@docker push jetblackpope/pybuntu:3.9.0a3-bionic
	@docker push jetblackpope/pybuntu:3.8.2rc2-bionic

	@docker tag jetblackpope/pybuntu:3.8.1-bionic jetblackpope/pybuntu:3-bionic
	@docker push jetblackpope/pybuntu:3-bionic

	@docker tag jetblackpope/pybuntu:3.8.1-bionic jetblackpope/pybuntu:3
	@docker push jetblackpope/pybuntu:3

	@docker tag jetblackpope/pybuntu:3.8.1-bionic jetblackpope/pybuntu:latest
	@docker push jetblackpope/pybuntu:latest

	@docker tag jetblackpope/pybuntu:3.9.0a3-disco jetblackpope/pybuntu:3.9-disco
	@docker push jetblackpope/pybuntu:3.9-disco

	@docker tag jetblackpope/pybuntu:3.8.1-bionic jetblackpope/pybuntu:3.8-bionic
	@docker push jetblackpope/pybuntu:3.8-bionic

	@docker tag jetblackpope/pybuntu:3.7.6-bionic jetblackpope/pybuntu:3.7-bionic
	@docker push jetblackpope/pybuntu:3.7-bionic

	@docker tag jetblackpope/pybuntu:3.6.10-bionic jetblackpope/pybuntu:3.6-bionic
	@docker push jetblackpope/pybuntu:3.6-bionic

	@docker tag jetblackpope/pybuntu:3.5.9-bionic jetblackpope/pybuntu:3.5-bionic
	@docker push jetblackpope/pybuntu:3.5-bionic

	@docker tag jetblackpope/pybuntu:2.7.17-bionic jetblackpope/pybuntu:2-bionic
	@docker push jetblackpope/pybuntu:2-bionic

	@docker tag jetblackpope/pybuntu:2.7.17-bionic jetblackpope/pybuntu:2.7-bionic
	@docker push jetblackpope/pybuntu:2.7-bionic

push: push_disco push_bionic
	@echo 'Pushing images up to dockerhub'
