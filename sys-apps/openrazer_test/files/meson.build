project('razer_test', 'cpp',
        version : '0.0.1',
        meson_version : '>=0.44.0',
        default_options : ['cpp_std=c++14'])

# Install public header
install_headers('include/razer_test.h')

# Install pkg-config file
pkg = import('pkgconfig')
pkg.generate(name: meson.project_name(),
             version: meson.project_version(), # Drop when meson is >= 0.46.0
             description: 'Header describing the enums and structs used in the D-Bus interface of razer_test')
