# PixelOS-specific overlays

Reserved for runtime resource overlays targeting PixelOS's own packages
(SystemUI, Settings and other PixelOS customizations in the `seventeen`
branch).

None could be derived on this machine: there is no PixelOS source tree here and
the stock dump carries no `product/overlay` APKs to compare against. Once the
build server has the PixelOS source, diff its default config against stock
NothingOS behavior and add the RRO modules here (one directory per module, same
`runtime_resource_overlay` pattern as `overlay/`).
