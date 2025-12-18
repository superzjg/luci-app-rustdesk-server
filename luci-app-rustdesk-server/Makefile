include $(TOPDIR)/rules.mk

PKG_VERSION:=20250610
PKG_RELEASE:=1
PKG_NAME:=luci-app-rustdesk-server

# 高版本24.10.4的sdk会增加依赖luci-lua-runtime导致低版本系统装不上ipk，建议22.03.7
LUCI_TITLE:=LuCI support for rustdesk-server
LUCI_DEPENDS:=+libc +luci-compat
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/rustdesk
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
