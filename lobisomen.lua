parse = require "ParserLpeg"
automaton = require "automaton"

print("Por favor entre seu codigo :")
expressao = io.stdin:read'*l'

while (expressao~='exit') do
    --print("Expressão: ",expressao)
    automaton.auto(parse.generator(expressao))
    expressao = io.stdin:read'*l'
end


