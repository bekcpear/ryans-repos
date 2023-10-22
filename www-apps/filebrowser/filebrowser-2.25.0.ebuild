# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go npm systemd

DESCRIPTION="Web File Browser"
HOMEPAGE="https://filebrowser.org https://github.com/filebrowser/filebrowser"

LICENSE="Apache-2.0 BSD-2 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# jq '.packages[].resolved' package-lock.json | sed -E '/^null$/d;s@^\"https://[^/]+/(.+)\"$@\"\1\"@' | sort -u | xclip
NPM_RESOLVED=(
	"@aashutoshrathi/word-wrap/-/word-wrap-1.2.6.tgz"
	"abab/-/abab-2.0.6.tgz"
	"ace-builds/-/ace-builds-1.23.4.tgz"
	"acorn/-/acorn-8.10.0.tgz"
	"acorn-jsx/-/acorn-jsx-5.3.2.tgz"
	"agent-base/-/agent-base-6.0.2.tgz"
	"ajv/-/ajv-6.12.6.tgz"
	"@ampproject/remapping/-/remapping-2.2.1.tgz"
	"ansi-regex/-/ansi-regex-5.0.1.tgz"
	"ansi-styles/-/ansi-styles-3.2.1.tgz"
	"ansi-styles/-/ansi-styles-4.3.0.tgz"
	"argparse/-/argparse-2.0.1.tgz"
	"asynckit/-/asynckit-0.4.0.tgz"
	"autoprefixer/-/autoprefixer-10.4.14.tgz"
	"@babel/code-frame/-/code-frame-7.22.10.tgz"
	"@babel/compat-data/-/compat-data-7.22.9.tgz"
	"@babel/core/-/core-7.22.10.tgz"
	"@babel/generator/-/generator-7.22.10.tgz"
	"@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.22.5.tgz"
	"@babel/helper-builder-binary-assignment-operator-visitor/-/helper-builder-binary-assignment-operator-visitor-7.22.10.tgz"
	"@babel/helper-compilation-targets/-/helper-compilation-targets-7.22.10.tgz"
	"@babel/helper-create-class-features-plugin/-/helper-create-class-features-plugin-7.22.10.tgz"
	"@babel/helper-create-regexp-features-plugin/-/helper-create-regexp-features-plugin-7.22.9.tgz"
	"@babel/helper-define-polyfill-provider/-/helper-define-polyfill-provider-0.4.2.tgz"
	"@babel/helper-environment-visitor/-/helper-environment-visitor-7.22.5.tgz"
	"@babel/helper-function-name/-/helper-function-name-7.22.5.tgz"
	"@babel/helper-hoist-variables/-/helper-hoist-variables-7.22.5.tgz"
	"@babel/helper-member-expression-to-functions/-/helper-member-expression-to-functions-7.22.5.tgz"
	"@babel/helper-module-imports/-/helper-module-imports-7.22.5.tgz"
	"@babel/helper-module-transforms/-/helper-module-transforms-7.22.9.tgz"
	"@babel/helper-optimise-call-expression/-/helper-optimise-call-expression-7.22.5.tgz"
	"@babel/helper-plugin-utils/-/helper-plugin-utils-7.22.5.tgz"
	"@babel/helper-remap-async-to-generator/-/helper-remap-async-to-generator-7.22.9.tgz"
	"@babel/helper-replace-supers/-/helper-replace-supers-7.22.9.tgz"
	"@babel/helpers/-/helpers-7.22.10.tgz"
	"@babel/helper-simple-access/-/helper-simple-access-7.22.5.tgz"
	"@babel/helper-skip-transparent-expression-wrappers/-/helper-skip-transparent-expression-wrappers-7.22.5.tgz"
	"@babel/helper-split-export-declaration/-/helper-split-export-declaration-7.22.6.tgz"
	"@babel/helper-string-parser/-/helper-string-parser-7.22.5.tgz"
	"@babel/helper-validator-identifier/-/helper-validator-identifier-7.22.5.tgz"
	"@babel/helper-validator-option/-/helper-validator-option-7.22.5.tgz"
	"@babel/helper-wrap-function/-/helper-wrap-function-7.22.10.tgz"
	"@babel/highlight/-/highlight-7.22.10.tgz"
	"@babel/parser/-/parser-7.22.10.tgz"
	"@babel/plugin-bugfix-safari-id-destructuring-collision-in-function-expression/-/plugin-bugfix-safari-id-destructuring-collision-in-function-expression-7.22.5.tgz"
	"@babel/plugin-bugfix-v8-spread-parameters-in-optional-chaining/-/plugin-bugfix-v8-spread-parameters-in-optional-chaining-7.22.5.tgz"
	"babel-plugin-polyfill-corejs2/-/babel-plugin-polyfill-corejs2-0.4.5.tgz"
	"babel-plugin-polyfill-corejs3/-/babel-plugin-polyfill-corejs3-0.8.3.tgz"
	"babel-plugin-polyfill-regenerator/-/babel-plugin-polyfill-regenerator-0.5.2.tgz"
	"@babel/plugin-proposal-private-property-in-object/-/plugin-proposal-private-property-in-object-7.21.0-placeholder-for-preset-env.2.tgz"
	"@babel/plugin-syntax-async-generators/-/plugin-syntax-async-generators-7.8.4.tgz"
	"@babel/plugin-syntax-class-properties/-/plugin-syntax-class-properties-7.12.13.tgz"
	"@babel/plugin-syntax-class-static-block/-/plugin-syntax-class-static-block-7.14.5.tgz"
	"@babel/plugin-syntax-dynamic-import/-/plugin-syntax-dynamic-import-7.8.3.tgz"
	"@babel/plugin-syntax-export-namespace-from/-/plugin-syntax-export-namespace-from-7.8.3.tgz"
	"@babel/plugin-syntax-import-assertions/-/plugin-syntax-import-assertions-7.22.5.tgz"
	"@babel/plugin-syntax-import-attributes/-/plugin-syntax-import-attributes-7.22.5.tgz"
	"@babel/plugin-syntax-import-meta/-/plugin-syntax-import-meta-7.10.4.tgz"
	"@babel/plugin-syntax-json-strings/-/plugin-syntax-json-strings-7.8.3.tgz"
	"@babel/plugin-syntax-logical-assignment-operators/-/plugin-syntax-logical-assignment-operators-7.10.4.tgz"
	"@babel/plugin-syntax-nullish-coalescing-operator/-/plugin-syntax-nullish-coalescing-operator-7.8.3.tgz"
	"@babel/plugin-syntax-numeric-separator/-/plugin-syntax-numeric-separator-7.10.4.tgz"
	"@babel/plugin-syntax-object-rest-spread/-/plugin-syntax-object-rest-spread-7.8.3.tgz"
	"@babel/plugin-syntax-optional-catch-binding/-/plugin-syntax-optional-catch-binding-7.8.3.tgz"
	"@babel/plugin-syntax-optional-chaining/-/plugin-syntax-optional-chaining-7.8.3.tgz"
	"@babel/plugin-syntax-private-property-in-object/-/plugin-syntax-private-property-in-object-7.14.5.tgz"
	"@babel/plugin-syntax-top-level-await/-/plugin-syntax-top-level-await-7.14.5.tgz"
	"@babel/plugin-syntax-unicode-sets-regex/-/plugin-syntax-unicode-sets-regex-7.18.6.tgz"
	"@babel/plugin-transform-arrow-functions/-/plugin-transform-arrow-functions-7.22.5.tgz"
	"@babel/plugin-transform-async-generator-functions/-/plugin-transform-async-generator-functions-7.22.10.tgz"
	"@babel/plugin-transform-async-to-generator/-/plugin-transform-async-to-generator-7.22.5.tgz"
	"@babel/plugin-transform-block-scoped-functions/-/plugin-transform-block-scoped-functions-7.22.5.tgz"
	"@babel/plugin-transform-block-scoping/-/plugin-transform-block-scoping-7.22.10.tgz"
	"@babel/plugin-transform-classes/-/plugin-transform-classes-7.22.6.tgz"
	"@babel/plugin-transform-class-properties/-/plugin-transform-class-properties-7.22.5.tgz"
	"@babel/plugin-transform-class-static-block/-/plugin-transform-class-static-block-7.22.5.tgz"
	"@babel/plugin-transform-computed-properties/-/plugin-transform-computed-properties-7.22.5.tgz"
	"@babel/plugin-transform-destructuring/-/plugin-transform-destructuring-7.22.10.tgz"
	"@babel/plugin-transform-dotall-regex/-/plugin-transform-dotall-regex-7.22.5.tgz"
	"@babel/plugin-transform-duplicate-keys/-/plugin-transform-duplicate-keys-7.22.5.tgz"
	"@babel/plugin-transform-dynamic-import/-/plugin-transform-dynamic-import-7.22.5.tgz"
	"@babel/plugin-transform-exponentiation-operator/-/plugin-transform-exponentiation-operator-7.22.5.tgz"
	"@babel/plugin-transform-export-namespace-from/-/plugin-transform-export-namespace-from-7.22.5.tgz"
	"@babel/plugin-transform-for-of/-/plugin-transform-for-of-7.22.5.tgz"
	"@babel/plugin-transform-function-name/-/plugin-transform-function-name-7.22.5.tgz"
	"@babel/plugin-transform-json-strings/-/plugin-transform-json-strings-7.22.5.tgz"
	"@babel/plugin-transform-literals/-/plugin-transform-literals-7.22.5.tgz"
	"@babel/plugin-transform-logical-assignment-operators/-/plugin-transform-logical-assignment-operators-7.22.5.tgz"
	"@babel/plugin-transform-member-expression-literals/-/plugin-transform-member-expression-literals-7.22.5.tgz"
	"@babel/plugin-transform-modules-amd/-/plugin-transform-modules-amd-7.22.5.tgz"
	"@babel/plugin-transform-modules-commonjs/-/plugin-transform-modules-commonjs-7.22.5.tgz"
	"@babel/plugin-transform-modules-systemjs/-/plugin-transform-modules-systemjs-7.22.5.tgz"
	"@babel/plugin-transform-modules-umd/-/plugin-transform-modules-umd-7.22.5.tgz"
	"@babel/plugin-transform-named-capturing-groups-regex/-/plugin-transform-named-capturing-groups-regex-7.22.5.tgz"
	"@babel/plugin-transform-new-target/-/plugin-transform-new-target-7.22.5.tgz"
	"@babel/plugin-transform-nullish-coalescing-operator/-/plugin-transform-nullish-coalescing-operator-7.22.5.tgz"
	"@babel/plugin-transform-numeric-separator/-/plugin-transform-numeric-separator-7.22.5.tgz"
	"@babel/plugin-transform-object-rest-spread/-/plugin-transform-object-rest-spread-7.22.5.tgz"
	"@babel/plugin-transform-object-super/-/plugin-transform-object-super-7.22.5.tgz"
	"@babel/plugin-transform-optional-catch-binding/-/plugin-transform-optional-catch-binding-7.22.5.tgz"
	"@babel/plugin-transform-optional-chaining/-/plugin-transform-optional-chaining-7.22.10.tgz"
	"@babel/plugin-transform-parameters/-/plugin-transform-parameters-7.22.5.tgz"
	"@babel/plugin-transform-private-methods/-/plugin-transform-private-methods-7.22.5.tgz"
	"@babel/plugin-transform-private-property-in-object/-/plugin-transform-private-property-in-object-7.22.5.tgz"
	"@babel/plugin-transform-property-literals/-/plugin-transform-property-literals-7.22.5.tgz"
	"@babel/plugin-transform-regenerator/-/plugin-transform-regenerator-7.22.10.tgz"
	"@babel/plugin-transform-reserved-words/-/plugin-transform-reserved-words-7.22.5.tgz"
	"@babel/plugin-transform-shorthand-properties/-/plugin-transform-shorthand-properties-7.22.5.tgz"
	"@babel/plugin-transform-spread/-/plugin-transform-spread-7.22.5.tgz"
	"@babel/plugin-transform-sticky-regex/-/plugin-transform-sticky-regex-7.22.5.tgz"
	"@babel/plugin-transform-template-literals/-/plugin-transform-template-literals-7.22.5.tgz"
	"@babel/plugin-transform-typeof-symbol/-/plugin-transform-typeof-symbol-7.22.5.tgz"
	"@babel/plugin-transform-unicode-escapes/-/plugin-transform-unicode-escapes-7.22.10.tgz"
	"@babel/plugin-transform-unicode-property-regex/-/plugin-transform-unicode-property-regex-7.22.5.tgz"
	"@babel/plugin-transform-unicode-regex/-/plugin-transform-unicode-regex-7.22.5.tgz"
	"@babel/plugin-transform-unicode-sets-regex/-/plugin-transform-unicode-sets-regex-7.22.5.tgz"
	"@babel/preset-env/-/preset-env-7.22.10.tgz"
	"@babel/preset-modules/-/preset-modules-0.1.6-no-external-plugins.tgz"
	"@babel/regjsgen/-/regjsgen-0.8.0.tgz"
	"@babel/runtime/-/runtime-7.22.10.tgz"
	"@babel/template/-/template-7.22.5.tgz"
	"@babel/traverse/-/traverse-7.22.10.tgz"
	"@babel/types/-/types-7.22.10.tgz"
	"balanced-match/-/balanced-match-1.0.2.tgz"
	"big-integer/-/big-integer-1.6.51.tgz"
	"boolbase/-/boolbase-1.0.0.tgz"
	"bplist-parser/-/bplist-parser-0.2.0.tgz"
	"brace-expansion/-/brace-expansion-1.1.11.tgz"
	"braces/-/braces-3.0.2.tgz"
	"browserslist/-/browserslist-4.21.10.tgz"
	"buffer-from/-/buffer-from-1.1.2.tgz"
	"bundle-name/-/bundle-name-3.0.0.tgz"
	"callsites/-/callsites-3.1.0.tgz"
	"caniuse-lite/-/caniuse-lite-1.0.30001519.tgz"
	"chalk/-/chalk-2.4.2.tgz"
	"chalk/-/chalk-4.1.2.tgz"
	"clipboard/-/clipboard-2.0.11.tgz"
	"color-convert/-/color-convert-1.9.3.tgz"
	"color-convert/-/color-convert-2.0.1.tgz"
	"color-name/-/color-name-1.1.3.tgz"
	"color-name/-/color-name-1.1.4.tgz"
	"combined-stream/-/combined-stream-1.0.8.tgz"
	"combine-errors/-/combine-errors-3.0.3.tgz"
	"commander/-/commander-2.20.3.tgz"
	"concat-map/-/concat-map-0.0.1.tgz"
	"connect-history-api-fallback/-/connect-history-api-fallback-1.6.0.tgz"
	"convert-source-map/-/convert-source-map-1.9.0.tgz"
	"core-js-compat/-/core-js-compat-3.32.0.tgz"
	"core-js/-/core-js-3.32.0.tgz"
	"cross-spawn/-/cross-spawn-7.0.3.tgz"
	"cssesc/-/cssesc-3.0.0.tgz"
	"cssstyle/-/cssstyle-3.0.0.tgz"
	"csstype/-/csstype-3.1.2.tgz"
	"css-vars-ponyfill/-/css-vars-ponyfill-2.4.8.tgz"
	"custom-error-instance/-/custom-error-instance-2.1.1.tgz"
	"data-urls/-/data-urls-4.0.0.tgz"
	"debug/-/debug-4.3.4.tgz"
	"decimal.js/-/decimal.js-10.4.3.tgz"
	"deep-is/-/deep-is-0.1.4.tgz"
	"default-browser/-/default-browser-4.0.0.tgz"
	"default-browser-id/-/default-browser-id-3.0.0.tgz"
	"define-lazy-prop/-/define-lazy-prop-3.0.0.tgz"
	"delayed-stream/-/delayed-stream-1.0.0.tgz"
	"delegate/-/delegate-3.2.0.tgz"
	"doctrine/-/doctrine-3.0.0.tgz"
	"domexception/-/domexception-4.0.0.tgz"
	"electron-to-chromium/-/electron-to-chromium-1.4.487.tgz"
	"entities/-/entities-4.5.0.tgz"
	"@esbuild/android-arm64/-/android-arm64-0.18.20.tgz"
	"@esbuild/android-arm/-/android-arm-0.18.20.tgz"
	"@esbuild/android-x64/-/android-x64-0.18.20.tgz"
	"@esbuild/darwin-arm64/-/darwin-arm64-0.18.20.tgz"
	"@esbuild/darwin-x64/-/darwin-x64-0.18.20.tgz"
	"esbuild/-/esbuild-0.18.20.tgz"
	"@esbuild/freebsd-arm64/-/freebsd-arm64-0.18.20.tgz"
	"@esbuild/freebsd-x64/-/freebsd-x64-0.18.20.tgz"
	"@esbuild/linux-arm64/-/linux-arm64-0.18.20.tgz"
	"@esbuild/linux-arm/-/linux-arm-0.18.20.tgz"
	"@esbuild/linux-ia32/-/linux-ia32-0.18.20.tgz"
	"@esbuild/linux-loong64/-/linux-loong64-0.18.20.tgz"
	"@esbuild/linux-mips64el/-/linux-mips64el-0.18.20.tgz"
	"@esbuild/linux-ppc64/-/linux-ppc64-0.18.20.tgz"
	"@esbuild/linux-riscv64/-/linux-riscv64-0.18.20.tgz"
	"@esbuild/linux-s390x/-/linux-s390x-0.18.20.tgz"
	"@esbuild/linux-x64/-/linux-x64-0.18.20.tgz"
	"@esbuild/netbsd-x64/-/netbsd-x64-0.18.20.tgz"
	"@esbuild/openbsd-x64/-/openbsd-x64-0.18.20.tgz"
	"@esbuild/sunos-x64/-/sunos-x64-0.18.20.tgz"
	"@esbuild/win32-arm64/-/win32-arm64-0.18.20.tgz"
	"@esbuild/win32-ia32/-/win32-ia32-0.18.20.tgz"
	"@esbuild/win32-x64/-/win32-x64-0.18.20.tgz"
	"escalade/-/escalade-3.1.1.tgz"
	"escape-string-regexp/-/escape-string-regexp-1.0.5.tgz"
	"escape-string-regexp/-/escape-string-regexp-4.0.0.tgz"
	"@eslint-community/eslint-utils/-/eslint-utils-4.4.0.tgz"
	"@eslint-community/regexpp/-/regexpp-4.6.2.tgz"
	"eslint-config-prettier/-/eslint-config-prettier-8.10.0.tgz"
	"eslint/-/eslint-8.46.0.tgz"
	"@eslint/eslintrc/-/eslintrc-2.1.1.tgz"
	"@eslint/js/-/js-8.46.0.tgz"
	"eslint-plugin-prettier/-/eslint-plugin-prettier-5.0.0.tgz"
	"eslint-plugin-vue/-/eslint-plugin-vue-9.16.1.tgz"
	"eslint-scope/-/eslint-scope-7.2.2.tgz"
	"eslint-visitor-keys/-/eslint-visitor-keys-3.4.2.tgz"
	"espree/-/espree-9.6.1.tgz"
	"esquery/-/esquery-1.5.0.tgz"
	"esrecurse/-/esrecurse-4.3.0.tgz"
	"estraverse/-/estraverse-5.3.0.tgz"
	"estree-walker/-/estree-walker-2.0.2.tgz"
	"esutils/-/esutils-2.0.3.tgz"
	"execa/-/execa-5.1.1.tgz"
	"execa/-/execa-7.2.0.tgz"
	"fast-deep-equal/-/fast-deep-equal-3.1.3.tgz"
	"fast-diff/-/fast-diff-1.3.0.tgz"
	"fast-glob/-/fast-glob-3.3.1.tgz"
	"fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz"
	"fast-levenshtein/-/fast-levenshtein-2.0.6.tgz"
	"fastq/-/fastq-1.15.0.tgz"
	"file-entry-cache/-/file-entry-cache-6.0.1.tgz"
	"filesize/-/filesize-10.0.8.tgz"
	"fill-range/-/fill-range-7.0.1.tgz"
	"find-up/-/find-up-5.0.0.tgz"
	"flat-cache/-/flat-cache-3.0.4.tgz"
	"flatted/-/flatted-3.2.7.tgz"
	"form-data/-/form-data-4.0.0.tgz"
	"fraction.js/-/fraction.js-4.2.0.tgz"
	"fsevents/-/fsevents-2.3.2.tgz"
	"fs.realpath/-/fs.realpath-1.0.0.tgz"
	"function-bind/-/function-bind-1.1.1.tgz"
	"gensync/-/gensync-1.0.0-beta.2.tgz"
	"get-css-data/-/get-css-data-2.1.0.tgz"
	"get-stream/-/get-stream-6.0.1.tgz"
	"globals/-/globals-11.12.0.tgz"
	"globals/-/globals-13.20.0.tgz"
	"glob/-/glob-7.2.3.tgz"
	"glob-parent/-/glob-parent-5.1.2.tgz"
	"glob-parent/-/glob-parent-6.0.2.tgz"
	"good-listener/-/good-listener-1.2.2.tgz"
	"graceful-fs/-/graceful-fs-4.2.11.tgz"
	"graphemer/-/graphemer-1.4.0.tgz"
	"has-flag/-/has-flag-3.0.0.tgz"
	"has-flag/-/has-flag-4.0.0.tgz"
	"has/-/has-1.0.3.tgz"
	"html-encoding-sniffer/-/html-encoding-sniffer-3.0.0.tgz"
	"http-proxy-agent/-/http-proxy-agent-5.0.0.tgz"
	"https-proxy-agent/-/https-proxy-agent-5.0.1.tgz"
	"human-signals/-/human-signals-2.1.0.tgz"
	"human-signals/-/human-signals-4.3.1.tgz"
	"@humanwhocodes/config-array/-/config-array-0.11.10.tgz"
	"@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz"
	"@humanwhocodes/object-schema/-/object-schema-1.2.1.tgz"
	"iconv-lite/-/iconv-lite-0.6.3.tgz"
	"ignore/-/ignore-5.2.4.tgz"
	"import-fresh/-/import-fresh-3.3.0.tgz"
	"imurmurhash/-/imurmurhash-0.1.4.tgz"
	"inflight/-/inflight-1.0.6.tgz"
	"inherits/-/inherits-2.0.4.tgz"
	"is-core-module/-/is-core-module-2.13.0.tgz"
	"is-docker/-/is-docker-2.2.1.tgz"
	"is-docker/-/is-docker-3.0.0.tgz"
	"isexe/-/isexe-2.0.0.tgz"
	"is-extglob/-/is-extglob-2.1.1.tgz"
	"is-glob/-/is-glob-4.0.3.tgz"
	"is-inside-container/-/is-inside-container-1.0.0.tgz"
	"is-number/-/is-number-7.0.0.tgz"
	"is-path-inside/-/is-path-inside-3.0.3.tgz"
	"is-potential-custom-element-name/-/is-potential-custom-element-name-1.0.1.tgz"
	"is-stream/-/is-stream-2.0.1.tgz"
	"is-stream/-/is-stream-3.0.0.tgz"
	"is-wsl/-/is-wsl-2.2.0.tgz"
	"@jridgewell/gen-mapping/-/gen-mapping-0.3.3.tgz"
	"@jridgewell/resolve-uri/-/resolve-uri-3.1.1.tgz"
	"@jridgewell/set-array/-/set-array-1.1.2.tgz"
	"@jridgewell/sourcemap-codec/-/sourcemap-codec-1.4.15.tgz"
	"@jridgewell/source-map/-/source-map-0.3.5.tgz"
	"@jridgewell/trace-mapping/-/trace-mapping-0.3.19.tgz"
	"js-base64/-/js-base64-3.7.5.tgz"
	"jsdom/-/jsdom-22.1.0.tgz"
	"jsesc/-/jsesc-0.5.0.tgz"
	"jsesc/-/jsesc-2.5.2.tgz"
	"json5/-/json5-2.2.3.tgz"
	"json-schema-traverse/-/json-schema-traverse-0.4.1.tgz"
	"json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz"
	"js-tokens/-/js-tokens-4.0.0.tgz"
	"js-yaml/-/js-yaml-4.1.0.tgz"
	"levn/-/levn-0.4.1.tgz"
	"locate-path/-/locate-path-6.0.0.tgz"
	"lodash._baseiteratee/-/lodash._baseiteratee-4.7.0.tgz"
	"lodash._basetostring/-/lodash._basetostring-4.12.0.tgz"
	"lodash._baseuniq/-/lodash._baseuniq-4.6.0.tgz"
	"lodash.clonedeep/-/lodash.clonedeep-4.5.0.tgz"
	"lodash._createset/-/lodash._createset-4.0.3.tgz"
	"lodash.debounce/-/lodash.debounce-4.0.8.tgz"
	"lodash/-/lodash-4.17.21.tgz"
	"lodash.merge/-/lodash.merge-4.6.2.tgz"
	"lodash._root/-/lodash._root-3.0.1.tgz"
	"lodash._stringtopath/-/lodash._stringtopath-4.8.0.tgz"
	"lodash.throttle/-/lodash.throttle-4.1.1.tgz"
	"lodash.uniqby/-/lodash.uniqby-4.5.0.tgz"
	"lru-cache/-/lru-cache-5.1.1.tgz"
	"lru-cache/-/lru-cache-6.0.0.tgz"
	"magic-string/-/magic-string-0.30.2.tgz"
	"material-icons/-/material-icons-1.13.9.tgz"
	"merge2/-/merge2-1.4.1.tgz"
	"merge-stream/-/merge-stream-2.0.0.tgz"
	"micromatch/-/micromatch-4.0.5.tgz"
	"mime-db/-/mime-db-1.52.0.tgz"
	"mime-types/-/mime-types-2.1.35.tgz"
	"mimic-fn/-/mimic-fn-2.1.0.tgz"
	"mimic-fn/-/mimic-fn-4.0.0.tgz"
	"minimatch/-/minimatch-3.1.2.tgz"
	"moment/-/moment-2.29.4.tgz"
	"ms/-/ms-2.1.2.tgz"
	"nanoid/-/nanoid-3.3.6.tgz"
	"natural-compare/-/natural-compare-1.4.0.tgz"
	"@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz"
	"@nodelib/fs.stat/-/fs.stat-2.0.5.tgz"
	"@nodelib/fs.walk/-/fs.walk-1.2.8.tgz"
	"node-releases/-/node-releases-2.0.13.tgz"
	"normalize.css/-/normalize.css-8.0.1.tgz"
	"normalize-range/-/normalize-range-0.1.2.tgz"
	"noty/-/noty-3.2.0-beta-deprecated.tgz"
	"npm-run-path/-/npm-run-path-4.0.1.tgz"
	"npm-run-path/-/npm-run-path-5.1.0.tgz"
	"nth-check/-/nth-check-2.1.1.tgz"
	"nwsapi/-/nwsapi-2.2.7.tgz"
	"once/-/once-1.4.0.tgz"
	"onetime/-/onetime-5.1.2.tgz"
	"onetime/-/onetime-6.0.0.tgz"
	"open/-/open-9.1.0.tgz"
	"optionator/-/optionator-0.9.3.tgz"
	"pako/-/pako-1.0.11.tgz"
	"parent-module/-/parent-module-1.0.1.tgz"
	"parse5/-/parse5-7.1.2.tgz"
	"path-exists/-/path-exists-4.0.0.tgz"
	"path-is-absolute/-/path-is-absolute-1.0.1.tgz"
	"path-key/-/path-key-3.1.1.tgz"
	"path-key/-/path-key-4.0.0.tgz"
	"path-parse/-/path-parse-1.0.7.tgz"
	"picocolors/-/picocolors-1.0.0.tgz"
	"picomatch/-/picomatch-2.3.1.tgz"
	"@pkgr/utils/-/utils-2.4.2.tgz"
	"p-limit/-/p-limit-3.1.0.tgz"
	"p-locate/-/p-locate-5.0.0.tgz"
	"postcss/-/postcss-8.4.27.tgz"
	"postcss-selector-parser/-/postcss-selector-parser-6.0.13.tgz"
	"postcss-value-parser/-/postcss-value-parser-4.2.0.tgz"
	"prelude-ls/-/prelude-ls-1.2.1.tgz"
	"prettier-linter-helpers/-/prettier-linter-helpers-1.0.0.tgz"
	"prettier/-/prettier-3.0.1.tgz"
	"pretty-bytes/-/pretty-bytes-6.1.1.tgz"
	"proper-lockfile/-/proper-lockfile-4.1.2.tgz"
	"psl/-/psl-1.9.0.tgz"
	"punycode/-/punycode-2.3.0.tgz"
	"qrcode.vue/-/qrcode.vue-1.7.0.tgz"
	"querystringify/-/querystringify-2.2.0.tgz"
	"queue-microtask/-/queue-microtask-1.2.3.tgz"
	"regenerate/-/regenerate-1.4.2.tgz"
	"regenerate-unicode-properties/-/regenerate-unicode-properties-10.1.0.tgz"
	"regenerator-runtime/-/regenerator-runtime-0.13.11.tgz"
	"regenerator-runtime/-/regenerator-runtime-0.14.0.tgz"
	"regenerator-transform/-/regenerator-transform-0.15.2.tgz"
	"regexpu-core/-/regexpu-core-5.3.2.tgz"
	"regjsparser/-/regjsparser-0.9.1.tgz"
	"requires-port/-/requires-port-1.0.0.tgz"
	"resolve-from/-/resolve-from-4.0.0.tgz"
	"resolve/-/resolve-1.22.4.tgz"
	"retry/-/retry-0.12.0.tgz"
	"reusify/-/reusify-1.0.4.tgz"
	"rimraf/-/rimraf-3.0.2.tgz"
	"@rollup/pluginutils/-/pluginutils-5.0.2.tgz"
	"rollup/-/rollup-3.27.2.tgz"
	"rrweb-cssom/-/rrweb-cssom-0.6.0.tgz"
	"run-applescript/-/run-applescript-5.0.0.tgz"
	"run-parallel/-/run-parallel-1.2.0.tgz"
	"safer-buffer/-/safer-buffer-2.1.2.tgz"
	"saxes/-/saxes-6.0.0.tgz"
	"select/-/select-1.1.2.tgz"
	"semver/-/semver-6.3.1.tgz"
	"semver/-/semver-7.5.4.tgz"
	"shebang-command/-/shebang-command-2.0.0.tgz"
	"shebang-regex/-/shebang-regex-3.0.0.tgz"
	"signal-exit/-/signal-exit-3.0.7.tgz"
	"source-map-js/-/source-map-js-1.0.2.tgz"
	"source-map/-/source-map-0.6.1.tgz"
	"source-map-support/-/source-map-support-0.5.21.tgz"
	"strip-ansi/-/strip-ansi-6.0.1.tgz"
	"strip-final-newline/-/strip-final-newline-2.0.0.tgz"
	"strip-final-newline/-/strip-final-newline-3.0.0.tgz"
	"strip-json-comments/-/strip-json-comments-3.1.1.tgz"
	"supports-color/-/supports-color-5.5.0.tgz"
	"supports-color/-/supports-color-7.2.0.tgz"
	"supports-preserve-symlinks-flag/-/supports-preserve-symlinks-flag-1.0.0.tgz"
	"symbol-tree/-/symbol-tree-3.2.4.tgz"
	"synckit/-/synckit-0.8.5.tgz"
	"systemjs/-/systemjs-6.14.1.tgz"
	"terser/-/terser-5.19.2.tgz"
	"text-table/-/text-table-0.2.0.tgz"
	"tiny-emitter/-/tiny-emitter-2.1.0.tgz"
	"titleize/-/titleize-3.0.0.tgz"
	"to-fast-properties/-/to-fast-properties-2.0.0.tgz"
	"@tootallnate/once/-/once-2.0.0.tgz"
	"to-regex-range/-/to-regex-range-5.0.1.tgz"
	"tough-cookie/-/tough-cookie-4.1.3.tgz"
	"tr46/-/tr46-4.1.1.tgz"
	"tslib/-/tslib-2.6.1.tgz"
	"tus-js-client/-/tus-js-client-3.1.1.tgz"
	"type-check/-/type-check-0.4.0.tgz"
	"type-fest/-/type-fest-0.20.2.tgz"
	"@types/eslint/-/eslint-8.44.1.tgz"
	"@types/estree/-/estree-1.0.1.tgz"
	"@types/json-schema/-/json-schema-7.0.12.tgz"
	"@types/node/-/node-20.4.8.tgz"
	"unicode-canonical-property-names-ecmascript/-/unicode-canonical-property-names-ecmascript-2.0.0.tgz"
	"unicode-match-property-ecmascript/-/unicode-match-property-ecmascript-2.0.0.tgz"
	"unicode-match-property-value-ecmascript/-/unicode-match-property-value-ecmascript-2.1.0.tgz"
	"unicode-property-aliases-ecmascript/-/unicode-property-aliases-ecmascript-2.1.0.tgz"
	"universalify/-/universalify-0.2.0.tgz"
	"untildify/-/untildify-4.0.0.tgz"
	"update-browserslist-db/-/update-browserslist-db-1.0.11.tgz"
	"uri-js/-/uri-js-4.4.1.tgz"
	"url-parse/-/url-parse-1.5.10.tgz"
	"utif/-/utif-3.1.0.tgz"
	"util-deprecate/-/util-deprecate-1.0.2.tgz"
	"@vitejs/plugin-legacy/-/plugin-legacy-4.1.1.tgz"
	"@vitejs/plugin-vue2/-/plugin-vue2-2.2.0.tgz"
	"vite-plugin-compression2/-/vite-plugin-compression2-0.10.3.tgz"
	"vite-plugin-rewrite-all/-/vite-plugin-rewrite-all-1.0.1.tgz"
	"vite/-/vite-4.4.9.tgz"
	"vue-async-computed/-/vue-async-computed-3.9.0.tgz"
	"@vue/compiler-sfc/-/compiler-sfc-2.7.14.tgz"
	"@vue/eslint-config-prettier/-/eslint-config-prettier-8.0.0.tgz"
	"vue-eslint-parser/-/vue-eslint-parser-9.3.1.tgz"
	"vue-i18n/-/vue-i18n-8.28.2.tgz"
	"vue-lazyload/-/vue-lazyload-1.3.5.tgz"
	"vue-router/-/vue-router-3.6.5.tgz"
	"vue-simple-progress/-/vue-simple-progress-1.1.1.tgz"
	"vue/-/vue-2.7.14.tgz"
	"vuex-router-sync/-/vuex-router-sync-5.0.0.tgz"
	"vuex/-/vuex-3.6.2.tgz"
	"w3c-xmlserializer/-/w3c-xmlserializer-4.0.0.tgz"
	"webidl-conversions/-/webidl-conversions-7.0.0.tgz"
	"whatwg-encoding/-/whatwg-encoding-2.0.0.tgz"
	"whatwg-fetch/-/whatwg-fetch-3.6.17.tgz"
	"whatwg-mimetype/-/whatwg-mimetype-3.0.0.tgz"
	"whatwg-url/-/whatwg-url-12.0.1.tgz"
	"which/-/which-2.0.2.tgz"
	"wrappy/-/wrappy-1.0.2.tgz"
	"ws/-/ws-8.13.0.tgz"
	"xmlchars/-/xmlchars-2.2.0.tgz"
	"xml-name-validator/-/xml-name-validator-4.0.0.tgz"
	"yallist/-/yallist-3.1.1.tgz"
	"yallist/-/yallist-4.0.0.tgz"
	"yocto-queue/-/yocto-queue-0.1.0.tgz"
)
npm_set_globals

MY_SHAPATCH_SUFFIX="npm-lockfile-to-sha512"
SRC_URI="https://github.com/filebrowser/filebrowser/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${NPM_RESOLVED_SRC_URI}
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

# all sha512 checksum in v2.25.0
# https://github.com/bekcpear/npm-lockfile-to-sha512.sh/archive/refs/tags/${P}.tar.gz -> ${P}-${MY_SHAPATCH_SUFFIX}.tar.gz"

DEPEND=""
RDEPEND="${DEPEND}
	acct-user/filebrowser
	acct-group/filebrowser
"
BDEPEND=">=dev-lang/go-1.20:="

# all sha512 checksum in v2.25.0
#PATCHES=(
#	"${WORKDIR}/${MY_SHAPATCH_SUFFIX}.sh-${P}/${MY_SHAPATCH_SUFFIX}.diff"
#)

GO_LDFLAGS="
	-X github.com/filebrowser/filebrowser/v2/version.Version=${PV}
	-X github.com/filebrowser/filebrowser/v2/version.CommitSHA=release"

src_unpack() {
	unpack ${P}.tar.gz
	unpack ${P}-vendor.tar.gz
	go_setup_vendor
	# all sha512 checksum in v2.25.0
	#unpack ${P}-${MY_SHAPATCH_SUFFIX}.tar.gz
	npm_add_cache
}

src_compile() {
	pushd frontend || die
	npm_set_config
	npm ci || die
	npm run build || die
	popd || die

	go_src_compile
}

src_install() {
	go_src_install

	insinto /etc/filebrowser
	keepdir /var/log/filebrowser
	fowners filebrowser:filebrowser /var/log/filebrowser
	doins "${FILESDIR}/filebrowser.toml"
	newconfd "${FILESDIR}/filebrowser.confd" filebrowser
	newinitd "${FILESDIR}/filebrowser.initd" filebrowser
	systemd_dounit "${FILESDIR}/filebrowser.service"
}