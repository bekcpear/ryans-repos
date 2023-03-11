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
 Package name                               | Version           | Role   | Homepage                                       | Description
============================================|===================|========|================================================|====================
 acct-group/ip7                             | 0                 |        |                                                | Group for the HTTP API service of net-misc/ip7
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-admin/z16                              | 9999              |        | https://github.com/bekcpear/z16                | A bash script project that aims to maintain dotfiles.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-crypt/keybase                          | 6.0.2-r1          |        | https://keybase.io/                            | Keybase command-line utility, and local service
   dev-lang/go                              | 1.19.6            | BD     | https://go.dev                                 | A concurrent garbage collected and typesafe programming language
                                            | 1.19.7            |        |                                                |
                                            | 1.20.1            |        |                                                |
                                            | 1.20.2            |        |                                                |
     app-eselect/eselect-go                 | 20230205          | RD     | https://github.com/bekcpear/eselect-go         | Manages multiple Go versions
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-i18n/fcitx-meta                        | 5.0.12            |        | https://fcitx-im.org                           | Merge this to pull in Fcitx packages
   app-i18n/fcitx-bamboo                    | 1.0.2             | RD     | https://github.com/fcitx/fcitx5-bamboo         | Typing Vietnamese by Bamboo core engine for Fcitx5
     app-i18n/fcitx                         | 5.0.22            |  D, RD | https://fcitx-im.org/                          | Fcitx (Flexible Context-aware Input Tool with eXtension) input method framework
       x11-libs/xcb-imdkit                  | 1.0.5             |  D, RD | https://github.com/fcitx/xcb-imdkit            | Input method development support for xcb
   app-i18n/fcitx-configtool                | 5.0.17            | RD     | https://fcitx-im.org/                          | GUI configuration tool for Fcitx
     app-i18n/fcitx-qt                      | 5.0.17            |  D, RD | https://fcitx-im.org/                          | Qt library and IM module for fcitx5
   app-i18n/fcitx-gtk                       | 5.0.22            | RD     | https://fcitx-im.org/                          | GTK IM module and glib based dbus client library for Fcitx
   app-i18n/fcitx-rime                      | 5.0.16            | RD     | https://fcitx-im.org/                          | Chinese RIME input methods for Fcitx
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-misc/razergenie                        | 9999              |        | https://github.com/z3ntu/RazerGenie            | Razer devices configurator
   dev-libs/libopenrazer                    | 9999              |  D, RD | https://github.com/z3ntu/libopenrazer          | Libraries for razergenie.
   sys-apps/openrazer                       | 3.5.1             | RD     | https://github.com/openrazer/openrazer         | A user-space daemon that allows you to manage your Razer peripherals.
     sys-apps/openrazer-driver              | 3.5.1             | RD     | https://github.com/openrazer/openrazer         | A collection of kernel drivers for Razer devices.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 dev-util/act                               | 0.2.43            |        | https://github.com/nektos/act                  | Run your GitHub Actions locally
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 dev-util/v2ray-geoip-generator             | 9999              |        | https://github.com/v2fly/geoip                 | GeoIP generator for V2Ray.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 kde-misc/krunner-pass                      | 9999              |        | https://github.com/bekcpear/krunner-pass       | (Modified type instead version) Integrates krunner with pass
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 media-gfx/weasis-bin                       | 4.0.2             |        | https://nroduit.github.io/                     | A DICOM viewer available as a desktop application or as a web-based application.
                                            | 4.0.3             |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 media-sound/qqmusic-bin                    | 1.1.5             |        | https://y.qq.com/download/download.html        | Tencent QQ Music for Linux.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-im/dendrite                            | 0.11.0            |        | https://github.com/matrix-org/dendrite         | Dendrite is a second-generation Matrix homeserver written in Go!
   acct-group/dendrite                      | 0                 | RD     |                                                | Group for the net-im/dendrite service
   acct-user/dendrite                       | 0                 | RD     |                                                | User for the net-im/dendrite service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-im/linuxqq-bin                         | 2.0.0_beta2_p1089 |        | https://im.qq.com/linuxqq/index.html           | Tencent QQ.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-misc/ip7                               | 9999              |        | https://github.com/bekcpear/ip7                | An IP address checker, powered by MaxMind GeoLite2 databases.
   acct-user/ip7                            | 0                 | RD     |                                                | User for the HTTP API service of net-misc/ip7
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-misc/keycloak-bin                      | 21.0.1            |        | https://github.com/keycloak/keycloak           | Open Source Identity and Access Management
   acct-group/keycloak                      | 0                 | RD     |                                                | Group for the keycloak daemon
   acct-user/keycloak                       | 0                 | RD     |                                                | User for the keycloak daemon
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-misc/matterbridge-bin                  | 1.26.0            |        | https://github.com/42wim/matterbridge          | a simple chat bridge, IRC | Matrix | Mattermost | Telegram | XMPP | And more...
   acct-group/matterbridge                  | 0                 | RD     |                                                | Group for the net-misc/matterbridge{,-bin} service
   acct-user/matterbridge                   | 0                 | RD     |                                                | User for the net-misc/matterbridge{,-bin} service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core                       | 4.45.2-r1         |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
                                            | 5.4.0             |        |                                                |
   dev-libs/v2ray-domain-list-community     | 5.20230216031305  | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999              |        |                                                |
   dev-libs/v2ray-domain-list-community-bin | 5.20230216031305  | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999              |        |                                                |
   dev-libs/v2ray-geoip-bin                 | 5.202302160443    | RD     | https://github.com/v2fly/geoip                 | GeoIP for V2Ray.
                                            | 9999              |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core-bin                   | 4.45.2            |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
                                            | 5.2.1             |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-vpn/headscale                          | 0.20.0            |        | https://github.com/juanfont/headscale          | An open source, self-hosted implementation of the Tailscale control server
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-vpn/tailscale                          | 1.36.2            |        | https://tailscale.com                          | Tailscale VPN client and CLI tools
   acct-group/derper                        | 0                 | RD     |                                                | Group for the DERP service of net-vpn/tailscale
   acct-user/derper                         | 0                 | RD     |                                                | User for the DERP service of net-vpn/tailscale
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 sys-apps/duf                               | 0.8.1             |        | https://github.com/muesli/duf                  | Disk Usage/Free Utility - a better 'df' alternative
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 www-apps/bark-server                       | 2.1.4             |        | https://github.com/Finb/bark-server            | A server that allows to get/push customized notifications
   acct-group/bark-server                   | 0                 | RD     |                                                | Group for the www-apps/bark-server service
   acct-user/bark-server                    | 0                 | RD     |                                                | User for the www-apps/bark-server service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 www-apps/cryptpad                          | 5.2.1             |        | https://github.com/xwiki-labs/cryptpad         | Collaboration suite, end-to-end encrypted and open-source.
   acct-group/cryptpad                      | 0                 | RD     |                                                | Group for the www-apps/cryptpad service
   acct-user/cryptpad                       | 0                 | RD     |                                                | User for the www-apps/cryptpad service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 www-apps/filebrowser                       | 2.23.0            |        | https://filebrowser.org                        | Web File Browser
   acct-group/filebrowser                   | 0                 | RD     |                                                | Group for the www-apps/filebrowser service
   acct-user/filebrowser                    | 0                 | RD     |                                                | User for the www-apps/filebrowser service
============================================|===================|========|================================================|====================
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
