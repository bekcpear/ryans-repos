## A personal ebuild repository

- Reponame: **`ryans`**
- Maintainer: **[cwittlut](https://github.com/bekcpear)**

can be added to the system by running:
```bash
eselect repository enable ryans
# you may need to install app-eselect/eselect-repository first
```

### Packages

```
 Package name                               | Version                | Role   | Homepage                                       | Description
============================================|========================|========|================================================|====================
 app-admin/z16                              | 9999                   |        | https://github.com/bekcpear/z16                | A bash script project that aims to maintain dotfiles.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-i18n/fcitx-meta                        | 5.0.12                 |        | https://fcitx-im.org                           | Merge this to pull in Fcitx packages
   app-i18n/fcitx-configtool                | 5.0.12                 | RD     | https://fcitx-im.org/                          | GUI configuration tool for Fcitx
     app-i18n/fcitx-qt                      | 5.0.11                 |  D, RD | https://fcitx-im.org/                          | Qt library and IM module for fcitx5
       app-i18n/fcitx                       | 5.0.15                 |  D, RD | https://fcitx-im.org/                          | Fcitx (Flexible Context-aware Input Tool with eXtension) input method framework
         x11-libs/xcb-imdkit                | 1.0.3                  |  D, RD | https://github.com/fcitx/xcb-imdkit            | Input method development support for xcb
   app-i18n/fcitx-gtk                       | 5.0.13                 | RD     | https://fcitx-im.org/                          | GTK IM module and glib based dbus client library for Fcitx
   app-i18n/fcitx-rime                      | 5.0.12                 | RD     | https://fcitx-im.org/                          | Chinese RIME input methods for Fcitx
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-misc/razergenie                        | 9999                   |        | https://github.com/z3ntu/RazerGenie            | Razer devices configurator
   dev-libs/libopenrazer                    | 9999                   |  D, RD | https://github.com/z3ntu/libopenrazer          | Libraries for razergenie.
     sys-apps/openrazer_test                | 9999                   |  D, RD | https://github.com/z3ntu/razer_test            | A work-in-progress replacement for OpenRazer.
   sys-apps/openrazer                       | 3.3.0                  | RD     | https://github.com/openrazer/openrazer         | A user-space daemon that allows you to manage your Razer peripherals.
     sys-apps/openrazer-driver              | 3.3.0                  | RD     | https://github.com/openrazer/openrazer         | A collection of kernel drivers for Razer devices.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-text/ydcv-rs                           | 0.4.7                  |        | https://github.com/farseerfc/ydcv-rs           | A rust version of YouDao Console Version
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 dev-util/v2ray-geoip-generator             | 9999                   |        | https://github.com/v2fly/geoip                 | GeoIP generator for V2Ray.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 kde-misc/krunner-pass                      | 9999                   |        | https://github.com/bekcpear/krunner-pass       | (Modified type instead version) Integrates krunner with pass
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 media-gfx/weasis-bin                       | 3.8.1                  |        | https://nroduit.github.io/                     | A DICOM viewer available as a desktop application or as a web-based application.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 media-sound/qqmusic-bin                    | 1.1.3                  |        | https://y.qq.com/download/download.html        | Tencent QQ Music for Linux.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-im/linuxqq-bin                         | 2.0.0_beta2_p1089      |        | https://im.qq.com/linuxqq/index.html           | Tencent QQ.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-misc/matterbridge-bin                  | 1.25.0                 |        | https://github.com/42wim/matterbridge          | a simple chat bridge, IRC | Matrix | Mattermost | Telegram | XMPP | And more...
   acct-group/matterbridge                  | 0                      | RD     |                                                | Group for the net-misc/matterbridge{,-bin} service
   acct-user/matterbridge                   | 0                      | RD     |                                                | User for the net-misc/matterbridge{,-bin} service
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core                       | 4.44.0-r2              |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
   dev-libs/v2ray-domain-list-community     | 4.43.0_p20211203092402 | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999                   |        |                                                |
   dev-libs/v2ray-domain-list-community-bin | 4.43.0_p20211203092402 | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999                   |        |                                                |
   dev-libs/v2ray-geoip-bin                 | 4.44.0_p202112060252   | RD     | https://github.com/v2fly/geoip                 | GeoIP for V2Ray.
                                            | 9999                   |        |                                                |
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core-bin                   | 4.44.0                 |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 sys-apps/duf                               | 0.8.1                  |        | https://github.com/muesli/duf                  | Disk Usage/Free Utility - a better 'df' alternative
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 www-apps/cryptpad                          | 4.14.0                 |        | https://github.com/xwiki-labs/cryptpad         | Collaboration suite, end-to-end encrypted and open-source.
   acct-group/cryptpad                      | 0                      | RD     |                                                | Group for the www-apps/cryptpad service
   acct-user/cryptpad                       | 0                      | RD     |                                                | User for the www-apps/cryptpad service
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 www-apps/filebrowser                       | 2.21.1                 |        | https://filebrowser.org                        | Web File Browser
   acct-group/filebrowser                   | 0                      | RD     |                                                | Group for the www-apps/filebrowser service
   acct-user/filebrowser                    | 0                      | RD     |                                                | User for the www-apps/filebrowser service
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
