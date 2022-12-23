#compdef keybase

local opts ret=1
opts=$(${words[@]:0:#words[@]-1} --generate-bash-completion)

if [[ -z $opts ]]; then
  _files && ret=0
else
  _arguments \
    "1:command:($opts)" \
    "*::sub-command:($opts)" && ret=0
fi

return $ret
