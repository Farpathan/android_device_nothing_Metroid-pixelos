# Stand-in kernel source for Lineage's generated_kernel_includes. The kernel is
# the stock prebuilt, so headers_install unpacks the stock QTI UAPI headers.
VERSION = 6
PATCHLEVEL = 6
SUBLEVEL = 0

HEADERS := $(CURDIR)/../prebuilt/kernel-headers.tar.gz

# The caf HALs include techpack headers as <display/drm/...>, <linux/...>.
.PHONY: headers_install
headers_install:
	mkdir -p $(O)
	gzip -d < $(HEADERS) | tar -x -C $(O)
	for d in $(O)/usr/techpack/*/include; do cp -r $$d/. $(O)/usr/include/; done
