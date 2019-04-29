all:
	@echo ">>install lua"
	sudo apt-get install lua5.2
	sudo apt-get install liblua5.2-dev
	@echo ">>Lua installed"
	@echo ">>install luarocks"
	sudo apt install luarocks
	@echo ">>install lpeg"
	sudo luarocks install lpeg
	@echo ">>execução do teste"
	lua ParserLpeg.lua


