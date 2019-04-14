lexit = require "lexit"  -- Import lexit module

node = require  "node" --Import node module

local parser = {}

--[[
	Na main podemos ter uma chamada tipo transformer.transform(parser.parse(lexit.lex(expressao)))
	Que ai o retorno disso poderiamos em si processar e fazer as paradasde colocar nas pilhas de controle e blablabla

]]


--pegarah o retorno do lexit, e organizarah em uma table feita de
function organizeLex(lex)
	organized = {}
	for lexstr,cat in lexit.lex("5 * ( 3 + 2 )") do
		temp = {lexstr,cat}  --mais passos q o necessario, mas funciono assim entao nao vo mexer
		table.insert(organized,temp)
	end

	return organized

end

function parser.parse(lex)

	lexTable = organizeLex(lex)

	treeBase = node("<exp>") --vamos escrever assim mesmo ? Tipo <dig> , ou quer algo mais facil tipo algo tipo 1 = exp , 2 = dig ?

	--Agora podemos comecar as comparacoes e fazer arvores

end

return parser 
