.PHONY: deps image checksum manifest ova clean

.DEFAULT_GOAL := ova

deps:
	@command -v packer
	@command -v qemu-system-x86_64
	@command -v qemu-img

image: deps
	@echo "Build QEMU x86_64 image"
	@packer init .
	@packer validate .
	@packer build .

checksum: image
	@echo "Create VMware file and checksum"
	@cp template.ovf image/ubuntu.ovf
	@cd image && sha256sum --tag ubuntu.ovf ubuntu-1.vmdk > sha256.sum

manifest: checksum
	@echo "Create VMware compatible manifest with custom checksum file"
	@cd image && sed 's/SHA256 (/SHA256(/' sha256.sum | sed 's/) =/)=/' > ubuntu.mf

ova: manifest
	@echo "Create OVA file"
	@cd image && \
	tar -cvf ubuntu.ova ubuntu.ovf ubuntu.mf ubuntu-1.vmdk && \
	sha256sum --tag -b ubuntu.ova > ubuntu.shasum
	@echo "Cleanup QEMU image and VMDK file"
	@mv image/packer-base-ubuntu-cloud-amd64 image/ubuntu.img

clean:
	@echo "Delete build artifacts"
	@rm -rf image
