install:
	@echo ">>install lua"
	sudo apt-get install lua5.2
	sudo apt-get install liblua5.2-dev
	@echo ">>Lua installed"
	@echo ">>install luarocks"
	sudo apt install luarocks
	@echo ">>install lpeg"
	sudo luarocks install lpeg

compile:
	@echo ">>execução do Lobisomen"
	lua lobisomen.lua

reset:
	@echo ">>removendo dependências"
	sudo apt remove luarocks
	sudo apt remove lua5.2
	sudo apt remove lua-sec
	sudo apt remove lua-socket
