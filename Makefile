#
# Copyright 2019 Xingwang Liao <kuoruan@gmail.com>
# Licensed to the public under the MIT License.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-v2ray
PKG_VERSION:=1.2.3
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Xingwang Liao <kuoruan@gmail.com>

LUCI_TITLE:=LuCI support for V2Ray
LUCI_DEPENDS:=+jshn +luci-lib-jsonc +ip +iptables +iptables-mod-tproxy
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/v2ray
/etc/v2ray/inbound-settings.json
/etc/v2ray/inbound-stream-settings.json
/etc/v2ray/outbound-settings.json
/etc/v2ray/outbound-stream-settings.json
/etc/v2ray/transport.json
endef

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/40_luci-v2ray ) && rm -f /etc/uci-defaults/40_luci-v2ray
fi

chmod 755 "$${IPKG_INSTROOT}/etc/init.d/v2ray" >/dev/null 2>&1
ln -sf "../init.d/v2ray" \
	"$${IPKG_INSTROOT}/etc/rc.d/S99v2ray" >/dev/null 2>&1
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature
