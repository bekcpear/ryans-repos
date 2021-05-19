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
 app-misc/razergenie                        | 9999                   |        | https://github.com/z3ntu/RazerGenie            | Razer devices configurator
   dev-libs/libopenrazer                    | 9999                   |  D, RD | https://github.com/z3ntu/libopenrazer          | Libraries for razergenie.
     sys-apps/openrazer_test                | 9999                   |  D, RD | https://github.com/z3ntu/razer_test            | A work-in-progress replacement for OpenRazer.
   sys-apps/openrazer                       | 3.0.1                  | RD     | https://github.com/openrazer/openrazer         | A user-space daemon that allows you to manage your Razer peripherals.
     sys-apps/openrazer-driver              | 3.0.1                  | RD     | https://github.com/openrazer/openrazer         | A collection of kernel drivers for Razer devices.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 app-text/ydcv-rs                           | 0.4.7                  |        | https://github.com/farseerfc/ydcv-rs           | A rust version of YouDao Console Version
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 dev-util/v2ray-geoip-generator             | 9999                   |        | https://github.com/v2fly/geoip                 | GeoIP generator for V2Ray.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 media-sound/qqmusic-bin                    | 1.0.9                  |        | https://y.qq.com/download/download.html        | Tencent QQ Music for Linux.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-im/linuxqq-bin                         | 2.0.0_beta2_p1089      |        | https://im.qq.com/linuxqq/index.html           | Tencent QQ.
--------------------------------------------|------------------------|--------|------------------------------------------------|--------------------
 net-proxy/v2ray-core                       | 4.38.3                 |        | https://github.com/v2fly/v2ray-core            | A platform for building proxies to bypass network restrictions.
   dev-libs/v2ray-domain-list-community     | 4.38.2_p20210430100800 | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999                   |        |                                                |
   dev-libs/v2ray-domain-list-community-bin | 4.38.2_p20210430100800 | RD     | https://github.com/v2fly/domain-list-community | Community managed domain list for V2Ray.
                                            | 9999                   |        |                                                |
   dev-libs/v2ray-geoip-bin                 | 4.38.2_p202104300531   | RD     | https://github.com/v2fly/geoip                 | GeoIP for V2Ray.
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
