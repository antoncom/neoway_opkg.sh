# neoway_opkg.sh
Neoway N725 module uses OpenWrt, but some familiar tools like LuCI, uhttpd, Lua, etc. are not included to the original firmware. Moreover, the firmware doesn't have opkg, and so you are unable to use feeds and get/install packages as usual.
In order to add package to N725 OpenWrt, user has to build the one form source using cross-compilation approach. Then the compiled files has to be put to the appropriate directory location on the device.
This prosess is too annoying to use. That's why there is an alternative of opkg package manager in the repository.

## The approach in short
OpenWrt packages you need are build using External Toolchain approach, described in the official OpenWrt website: https://openwrt.org/docs/guide-developer/external_toolchain
Once you got the .IPK file of the compiled package, push the file to the N725 device and use opkg.sh to unpack and populate the device's folder with the compiled files.
