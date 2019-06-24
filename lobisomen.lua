parse = require "ParserLpeg"
automaton = require "automaton"

--[[

Para se utilizar do lobisomen.lua se utilize o arquivo "entrada.txt" e escreva o codigo que queira rodar lah

]]


local f = assert(io.open("entrada.txt", "rb"))
local entrada = f:read("*all")
f:close()

automaton.auto(parse.generator(entrada))
