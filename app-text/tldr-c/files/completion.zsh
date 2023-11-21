#compdef tldr

local -a pages platforms
pages=$(env TLDR_AUTO_UPDATE_DISABLED=1 tldr --list)
local ret=$?
platforms='( linux osx sunos windows )'

_arguments \
  '(- *)'{-v,--version}'[display version]' \
  '(- *)'{-h,--help}'[show help]' \
  '(- *)'{-l,--list}'[list all commands for chosen platform]' \
  '(-f --render)'{-f,--render}'[render a specific markdown file]:markdown file:_files -/' \
  '(- *)'{-u,--update}'[update local cache]' \
  '(- *)'{-c,--clear-cache}'[clear local cache]' \
  '(-p --platform)'{-p,--platform}"[override platform]:platform:(${(j:|:)platforms})" \
  '--linux[override operating system with Linux]' \
  '--osx[override operating system with macOS]' \
  '--sunos[override operating system with SunOS]' \
  '(- *)'{-c,--clear-cache}'[clear local cache]' \
  "*:page:(${(b)pages})"

return $ret
