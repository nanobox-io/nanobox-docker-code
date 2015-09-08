all: build publish

stability?=latest

login:
	@vagrant ssh -c "docker login"

build:
	@echo "Building 'code' image..."
	@vagrant ssh -c "docker build -t nanobox/code /vagrant"

publish:
	@echo "Tagging 'code' image..."
	@vagrant ssh -c "docker tag nanobox/code nanobox/code:${stability}"
	@echo "Publishing 'code:${stability}'..."
	@vagrant ssh -c "docker push nanobox/code:${stability}"

clean:
	@echo "Removing all images..."
	@vagrant ssh -c "docker rmi $(docker images -q)"
