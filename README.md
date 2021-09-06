## A personal ebuild repository

- Reponame: **`ryans`**
- Maintainer: **[bekcpear](https://github.com/bekcpear)**

can be added to the system by running:
```
eselect repository add ryans
```

### Packages

```
 Package name                               | Version                | Role   | Homepage                                       | Description
============================================|========================|========|================================================|====================
 app-admin/z16                              | 9999                   |        | https://github.com/bekcpear/z16                | A bash script project that aims to maintain dotfiles.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-i18n/fcitx-rime                        | 5.0.6                  |        | https://fcitx-im.org/                          | Chinese RIME input methods for Fcitx
   app-i18n/fcitx-meta                      | 5.0.8                  |  D, RD | https://fcitx-im.org                           | Merge this to pull in Fcitx packages
     app-i18n/fcitx-configtool              | 5.0.5                  | RD     | https://fcitx-im.org/                          | GUI configuration tool for Fcitx
       app-i18n/fcitx-qt                    | 5.0.6                  |  D, RD | https://fcitx-im.org/                          | Qt library and IM module for fcitx5
         app-i18n/fcitx                     | 5.0.8                  |  D, RD | https://fcitx-im.org/                          | Fcitx (Flexible Context-aware Input Tool with eXtension) input method framework
           x11-libs/xcb-imdkit              | 1.0.3                  |  D, RD | https://github.com/fcitx/xcb-imdkit            | Input method development support for xcb
     app-i18n/fcitx-gtk                     | 5.0.7                  | RD     | https://fcitx-im.org/                          | GTK IM module and glib based dbus client library for Fcitx
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-misc/razergenie                        | 9999                   |        | https://github.com/z3ntu/RazerGenie            | Razer devices configurator
   dev-libs/libopenrazer                    | 9999                   |  D, RD | https://github.com/z3ntu/libopenrazer          | Libraries for razergenie.
     sys-apps/openrazer_test                | 9999                   |  D, RD | https://github.com/z3ntu/razer_test            | A work-in-progress replacement for OpenRazer.
   sys-apps/openrazer                       | 3.1.0                  | RD     | https://github.com/openrazer/openrazer         | A user-space daemon that allows you to manage your Razer peripherals.
     sys-apps/openrazer-driver              | 3.1.0                  | RD     | https://github.com/openrazer/openrazer         | A collection of kernel drivers for Razer devices.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-text/ydcv-rs                           | 0.4.7                  |        | https://github.com/farseerfc/ydcv-rs           | A rust version of YouDao Console Version
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 dev-util/v2ray-geoip-generator             | 9999                   |        | https://github.com/v2fly/geoip                 | GeoIP generator for V2Ray.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 kde-apps/krunner-pass                      | 9999                   |        | https://github.com/bekcpear/krunner-pass       | (Modified type instead version) Integrates krunner with pass
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 media-sound/qqmusic-bin                    | 1.1.1                  |        | https://y.qq.com/download/download.html        | Tencent QQ Music for Linux.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-im/linuxqq-bin                         | 2.0.0_beta2_p1089      |        | https://im.qq.com/linuxqq/index.html           | Tencent QQ.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core                       | 4.41.1                 |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
   dev-libs/v2ray-domain-list-community     | 4.41.1_p20210816014827 | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999                   |        |                                                |
   dev-libs/v2ray-domain-list-community-bin | 4.41.1_p20210816014827 | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999                   |        |                                                |
   dev-libs/v2ray-geoip-bin                 | 4.41.1_p202108120026   | RD     | https://github.com/v2fly/geoip                 | GeoIP for V2Ray.
                                            | 9999                   |        |                                                |
============================================|========================|========|================================================|====================
```
+ ` D` means the classic dependencies (e.g.: libraries and headers)
+ `BD` means the build dependencies (e.g.: virtual/pkgconfig)
+ `RD` means runtime dependencies

_(All these dependencies are parsed literally.)_

### Maintenance status

+ dev-util/v2ray-geoip-generator

is under lazy maintained.

No package is under inactive maintained.

### License

[GPL-2.0](LICENSE)
