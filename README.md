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
 app-admin/z16                              | 9999              |        | https://github.com/bekcpear/z16                | A bash script project that aims to maintain dotfiles.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-crypt/keybase                          | 6.0.2-r1          |        | https://keybase.io/                            | Keybase command-line utility, and local service
                                            | 6.2.3             |        |                                                |
   dev-lang/go                              | 1.20.13           | BD     | https://go.dev                                 | A concurrent garbage collected and typesafe programming language
                                            | 1.21.6            |        |                                                |
     app-eselect/eselect-go                 | 20230312          | RD     | https://github.com/bekcpear/eselect-go         | Manages multiple Go versions
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-i18n/fcitx-meta                        | 5.0.12            |        | https://fcitx-im.org                           | Merge this to pull in Fcitx packages
   app-i18n/fcitx-bamboo                    | 1.0.4             | RD     | https://github.com/fcitx/fcitx5-bamboo         | Typing Vietnamese by Bamboo core engine for Fcitx5
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-misc/razergenie                        | 9999              |        | https://github.com/z3ntu/RazerGenie            | Razer devices configurator
   dev-libs/libopenrazer                    | 9999              |  D, RD | https://github.com/z3ntu/libopenrazer          | Libraries for razergenie.
   sys-apps/openrazer                       | 3.6.1             | RD     | https://github.com/openrazer/openrazer         | A user-space daemon that allows you to manage your Razer peripherals.
     sys-apps/openrazer-driver              | 3.6.1             | RD     | https://github.com/openrazer/openrazer         | A collection of kernel drivers for Razer devices.
                                            | 3.6.1-r1          |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 app-text/tldr-c                            | 1.6.1             |        | https://github.com/tldr-pages/tldr-c-client    | C command-line client for tldr pages
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 dev-util/act                               | 0.2.57            |        | https://github.com/nektos/act                  | Run your GitHub Actions locally
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 dev-util/v2ray-geoip-generator             | 9999              |        | https://github.com/v2fly/geoip                 | GeoIP generator for V2Ray.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 kde-misc/krunner-pass                      | 9999              |        | https://github.com/bekcpear/krunner-pass       | (Modified type instead version) Integrates krunner with pass
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 media-gfx/weasis-bin                       | 4.2.0             |        | https://nroduit.github.io/                     | A DICOM viewer available as a desktop application or as a web-based application.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 media-sound/qqmusic-bin                    | 1.1.5             |        | https://y.qq.com/download/download.html        | Tencent QQ Music for Linux.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-im/dendrite                            | 0.12.0            |        | https://github.com/matrix-org/dendrite         | Dendrite is a second-generation Matrix homeserver written in Go!
                                            | 0.13.4            |        |                                                |
   acct-group/dendrite                      | 0                 | RD     |                                                | Group for the net-im/dendrite service
   acct-user/dendrite                       | 0                 | RD     |                                                | User for the net-im/dendrite service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-im/linuxqq-bin                         | 2.0.0_beta2_p1089 |        | https://im.qq.com/linuxqq/index.html           | Tencent QQ.
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-misc/keycloak-bin                      | 21.0.1            |        | https://github.com/keycloak/keycloak           | Open Source Identity and Access Management
                                            | 22.0.5            |        |                                                |
   acct-group/keycloak                      | 0                 | RD     |                                                | Group for the keycloak daemon
   acct-user/keycloak                       | 0                 | RD     |                                                | User for the keycloak daemon
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-misc/matterbridge-bin                  | 1.26.0            |        | https://github.com/42wim/matterbridge          | a simple chat bridge, IRC | Matrix | Mattermost | Telegram | XMPP | And more...
   acct-group/matterbridge                  | 0                 | RD     |                                                | Group for the net-misc/matterbridge{,-bin} service
   acct-user/matterbridge                   | 0                 | RD     |                                                | User for the net-misc/matterbridge{,-bin} service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core                       | 4.45.2-r1         |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
                                            | 5.13.0            |        |                                                |
   dev-libs/v2ray-domain-list-community     | 5.20231215153121  | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999              |        |                                                |
   dev-libs/v2ray-domain-list-community-bin | 5.20231215153121  | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999              |        |                                                |
   dev-libs/v2ray-geoip-bin                 | 5.202312140039    | RD     | https://github.com/v2fly/geoip                 | GeoIP for V2Ray.
                                            | 9999              |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core-bin                   | 4.45.2            |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
                                            | 5.2.1             |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-vpn/headscale                          | 0.22.3            |        | https://github.com/juanfont/headscale          | An open source, self-hosted implementation of the Tailscale control server
                                            | 0.23.0_alpha2     |        |                                                |
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 net-vpn/tailscale                          | 1.38.4            |        | https://tailscale.com                          | Tailscale VPN client and CLI tools
                                            | 1.42.0            |        |                                                |
                                            | 1.56.1            |        |                                                |
   acct-group/derper                        | 0                 | RD     |                                                | Group for the DERP service of net-vpn/tailscale
   acct-user/derper                         | 0                 | RD     |                                                | User for the DERP service of net-vpn/tailscale
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 sys-apps/duf                               | 0.8.1             |        | https://github.com/muesli/duf                  | Disk Usage/Free Utility - a better 'df' alternative
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 www-apps/bark-server                       | 2.1.4             |        | https://github.com/Finb/bark-server            | A server that allows to get/push customized notifications
                                            | 2.1.5             |        |                                                |
   acct-group/bark-server                   | 0                 | RD     |                                                | Group for the www-apps/bark-server service
   acct-user/bark-server                    | 0                 | RD     |                                                | User for the www-apps/bark-server service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 www-apps/cryptpad                          | 5.2.1             |        | https://github.com/xwiki-labs/cryptpad         | Collaboration suite, end-to-end encrypted and open-source.
                                            | 5.5.0             |        |                                                |
   acct-group/cryptpad                      | 0                 | RD     |                                                | Group for the www-apps/cryptpad service
   acct-user/cryptpad                       | 0                 | RD     |                                                | User for the www-apps/cryptpad service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 www-apps/filebrowser                       | 2.27.0            |        | https://filebrowser.org                        | Web File Browser
   acct-group/filebrowser                   | 0                 | RD     |                                                | Group for the www-apps/filebrowser service
   acct-user/filebrowser                    | 0                 | RD     |                                                | User for the www-apps/filebrowser service
--------------------------------------------|-------------------|--------|------------------------------------------------|--------------------
 x11-libs/xcb-imdkit                        | 1.0.5             |        | https://github.com/fcitx/xcb-imdkit            | Input method development support for xcb
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
