#############################################################
#
# mtd provides jffs2 utilities
#
#############################################################
MTD_VERSION:=1.4.1
MTD_SOURCE:=mtd-utils-$(MTD_VERSION).tar.bz2
MTD_SITE:=ftp://ftp.infradead.org/pub/mtd-utils
ifeq ($(BR2_PACKAGE_MTD_MKFSJFFS2),y)
MTD_DEPENDENCIES = zlib lzo
endif
ifeq ($(BR2_PACKAGE_MTD_MKFSUBIFS),y)
MTD_DEPENDENCIES = zlib lzo
endif

HOST_MTD_DEPENDENCIES = host-zlib host-lzo host-e2fsprogs

define HOST_MTD_BUILD_CMDS
	CC="$(HOSTCC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)" \
		CROSS= $(MAKE1) BUILDDIR=$(@D) \
		WITHOUT_XATTR=1 -C $(@D)
endef

define HOST_MTD_INSTALL_CMDS
	$(MAKE1) BUILDDIR=$(@D) DESTDIR=$(HOST_DIR) -C $(@D) install
endef

MKFS_JFFS2=$(HOST_DIR)/usr/sbin/mkfs.jffs2
MKFS_UBIFS=$(HOST_DIR)/usr/sbin/mkfs.ubifs
SUMTOOL=$(HOST_DIR)/usr/sbin/sumtool

MTD_TARGETS_$(BR2_PACKAGE_MTD_DOCFDISK)		+= docfdisk
MTD_TARGETS_$(BR2_PACKAGE_MTD_DOC_LOADBIOS)	+= doc_loadbios
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASHCP)		+= flashcp
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASE)	+= flash_erase
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_ERASEALL)	+= flash_eraseall
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_INFO)	+= flash_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_LOCK)	+= flash_lock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_DUMP)	+= flash_otp_dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_OTP_INFO)	+= flash_otp_info
MTD_TARGETS_$(BR2_PACKAGE_MTD_FLASH_UNLOCK)	+= flash_unlock
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_CHECK)	+= ftl_check
MTD_TARGETS_$(BR2_PACKAGE_MTD_FTL_FORMAT)	+= ftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_JFFS2DUMP)	+= jffs2dump
MTD_TARGETS_$(BR2_PACKAGE_MTD_MKFSJFFS2)	+= mkfs.jffs2
MTD_TARGETS_$(BR2_PACKAGE_MTD_MTD_DEBUG)	+= mtd_debug
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDDUMP)		+= nanddump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDTEST)		+= nandtest
MTD_TARGETS_$(BR2_PACKAGE_MTD_NANDWRITE)	+= nandwrite
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTLDUMP)		+= nftldump
MTD_TARGETS_$(BR2_PACKAGE_MTD_NFTL_FORMAT)	+= nftl_format
MTD_TARGETS_$(BR2_PACKAGE_MTD_RECV_IMAGE)	+= recv_image
MTD_TARGETS_$(BR2_PACKAGE_MTD_RFDDUMP)		+= rfddump
MTD_TARGETS_$(BR2_PACKAGE_MTD_RFDFORMAT)	+= rfdformat
MTD_TARGETS_$(BR2_PACKAGE_MTD_SERVE_IMAGE)	+= serve_image
MTD_TARGETS_$(BR2_PACKAGE_MTD_SUMTOOL)		+= sumtool

MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_MTDINFO)	+= mtdinfo
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIATTACH)	+= ubiattach
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBICRC32)	+= ubicrc32
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIDETACH)	+= ubidetach
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIFORMAT)	+= ubiformat
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIMKVOL)	+= ubimkvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBINFO)	+= ubinfo
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBINIZE)	+= ubinize
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRENAME)	+= ubirename
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRMVOL)	+= ubirmvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIRSVOL)	+= ubirsvol
MTD_TARGETS_UBI_$(BR2_PACKAGE_MTD_UBIUPDATEVOL)	+= ubiupdatevol
MTD_TARGETS_UBIFS_$(BR2_PACKAGE_MTD_MKFSUBIFS)	+= mkfs.ubifs

MTD_MAKE_COMMON_FLAGS = \
	$(TARGET_CONFIGURE_OPTS) CROSS=$(TARGET_CROSS) \
	WITHOUT_XATTR=1 WITHOUT_LARGEFILE=1

define MTD_TARGETS_BUILD
	$(MAKE1) $(MTD_MAKE_COMMON_FLAGS) \
		BUILDDIR=$(@D) \
		-C $(@D) \
		$(addprefix $(@D)/, lib/libmtd.a $(MTD_TARGETS_y))
endef

ifneq ($(MTD_TARGETS_UBI_y),)
define MTD_TARGETS_UBI_BUILD
	$(MAKE1) $(MTD_MAKE_COMMON_FLAGS) \
		BUILDDIR=$(@D)/ubi-utils/ \
		-C $(@D)/ubi-utils \
		$(addprefix $(@D)/ubi-utils/, $(MTD_TARGETS_UBI_y))
endef
endif

ifneq ($(MTD_TARGETS_UBIFS_y),)
define MTD_TARGETS_UBIFS_BUILD
	$(MAKE1) $(MTD_MAKE_COMMON_FLAGS) \
		BUILDDIR=$(@D)/mkfs.ubifs/ \
		-C $(@D)/mkfs.ubifs \
		$(addprefix $(@D)/mkfs.ubifs/, $(MTD_TARGETS_UBIFS_y))
endef
endif

define MTD_BUILD_CMDS
 $(MTD_TARGETS_BUILD)
 $(MTD_TARGETS_UBI_BUILD)
 $(MTD_TARGETS_UBIFS_BUILD)
endef

define MTD_INSTALL_TARGET_CMDS
 for f in $(MTD_TARGETS_y) ; do \
  install -m 0755 $(@D)/$$f $(TARGET_DIR)/usr/sbin/$$f ; \
 done ; \
 for f in $(MTD_TARGETS_UBI_y) ; do \
  install -m 0755 $(@D)/ubi-utils/$$f $(TARGET_DIR)/usr/sbin/$$f ; \
 done
 for f in $(MTD_TARGETS_UBIFS_y) ; do \
  install -m 0755 $(@D)/mkfs.ubifs/$$f $(TARGET_DIR)/usr/sbin/$$f ; \
 done
endef

$(eval $(call GENTARGETS,package,mtd))
$(eval $(call GENTARGETS,package,mtd,host))
