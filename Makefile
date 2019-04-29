all:
        @echo ">>install lua"
        sudo apt install lua5.
        sudo apt-get install liblua5.2-dev
        @echo ">>Lua installed
        @echo ">>install luarocks"
        sudo apt install luarocks
        @echo ">>install lpeg"
        sudo luarocks install lpeg
        lua ParserLpeg.lua

