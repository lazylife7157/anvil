PLATFORM=`uname -s`


if [ "$PLATFORM" == "Darwin" ]; then
    export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
    export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
fi

# Pyenv
# ----------------------------------------------------------------------------
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
