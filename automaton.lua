--[[

Referencia : https://github.com/ChristianoBraga/PiFramework/blob/master/doc/pi-in-a-nutshell.md

Expressoes aritimeticas

NUM numero 			
SUM soma 			
SUB subtracao
MUL multiplicacao
DIV divisao
LT  menor que 
LE	menor ou igual
GT 	maior que
GE  maior ou igual

Expressoes booleanas 

BOO booleana
AND e
OR  ou
NOT nao

Comandos

ASSING



]]



function tLen(T) --Prasaber o tamanho da tabela | serio nao use  # nao eh deterministico
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function pop(pile)
	if pile ~= {} then
		lastIndex = tLen(pile)
		value = pile[lastIndex]
		table.remove(pile,lastIndex)
		return value
	end
end

function push(pile,item)
	table.insert(pile,item) --como nao tem valor coloca no final
end

function handle_NUM(item,cPile,vPile,env,stor,result)
	push(vPile,item)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_SUM(item,cPile,vPile,env,stor,result)
	OP = "#SUM"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_SUM(item,cPile,vPile,env,stor,result)--#SUM , soma dos dois primeiros itens em vPile
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	result = valueA + valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_SUB(item,cPile,vPile,env,stor,result)
	OP = "#SUB"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_SUB(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	result = valueA - valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_MUL(item,cPile,vPile,env,stor,result)
	OP = "#MUL"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_MUL(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	result = valueA * valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_DIV(item,cPile,vPile,env,stor,result)
	OP = "#DIV"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_DIV(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	result = valueA / valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_LT(item,cPile,vPile,env,stor,result)
	OP = "#LT"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_LT(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	if valueA < valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_LE(item,cPile,vPile,env,stor,result)
	OP = "#LE"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_LE(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	if valueA <= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_GT(item,cPile,vPile,env,stor,result)
	OP = "#GT"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_GT(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	if valueA > valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_GE(item,cPile,vPile,env,stor,result)
	OP = "#GE"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_GE(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	if valueA >= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_BOO(item,cPile,vPile,env,stor,result)
	push(vPile,item)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_AND(item,cPile,vPile,env,stor,result)
	OP = "#AND"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_AND(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	if valueA and valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end


function handle_OR(item,cPile,vPile,env,stor,result)
	OP = "#OR"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_OR(item,cPile,vPile,env,stor,result)
	valueA = node.value(pop(vPile))
	valueB = node.value(pop(vPile))
	if valueA or valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_NOT(item,cPile,vPile,env,stor,result)
	OP = "#NOT"
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,result)
end

function handle_H_NOT(item,cPile,vPile,env,stor,result)
	value = node.value(pop(vPile)) --nesse caso apenas um valor
	if value then
		result="FALSE"
	else
		result="TRUE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,result)
end

handlers =
    {
        ["NUM"]=handle_NUM,
        ["SUM"]=handle_SUM,
        ["#SUM"]=handle_H_SUM,
        ["SUB"]=handle_SUB,
        ["#SUB"]=handle_H_SUB,
        ["MUL"]=handle_MUL,
        ["#MUL"]=handle_H_MUL,
        ["DIV"]=handle_DIV,
        ["#DIV"]=handle_H_DIV,
        ["BOO"]=handle_BOO,
        ["LT"]=handle_LT,
        ["#LT"]=handle_H_LT,
        ["LE"]=handle_LE,
        ["#LE"]=handle_H_LE,
        ["GT"]=handle_GT,
        ["#GT"]=handle_H_GT,
        ["GE"]=handle_GE,
        ["#GE"]=handle_H_GE,
        ["AND"]=handle_AND,
        ["#AND"]=handle_H_AND,
        ["OR"]=handle_OR,
        ["#OR"]=handle_H_OR,
        ["NOT"]=handle_NOT,
        ["#NOT"]=handle_H_NOT,
    }




--Funcao recursiva simples que apenas ve o que eh pedido e envia para outra funcao
function automaton.rec(cPile,vPile,env,stor,result)
	if cPile ~= {} then
		return result
	end

	item = pop(cPile)

	stat=getStatement(item) --stat para statement, pois pode  ser operacao ou comando

	handlers[stat](item,cPile,vPile,env,stor,result)


end

function automaton.auto(tree)

	cPile={} --control pile
	vPile={} --value pile
	env={} 	 --enviroment
	sto={}   --storage

	result=0 --apenas iniciando variavel de retorno final



	push(cPile,tree)

	reusult = automaton.rec(cPile,vPile,env,stor,result)

end




--[[
	if stat=="NUM" then

		handle_NUM(cPile,vPile,env,stor,result)

	elseif stat=="SUM" then

		handle_SUM(cPile,vPile,env,stor,result)

	elseif stat=="SUB" then

		handle_SUB(cPile,vPile,env,stor,result)

	elseif stat=="MUL" then

		handle_MUL(cPile,vPile,env,stor,result)

	elseif stat=="DIV" then

		handle_DIV(cPile,vPile,env,stor,result)

	elseif stat=="BOO" then

 		handle_BOO(cPile,vPile,env,stor,result)

	elseif stat=="LT" then

		handle_LT(cPile,vPile,env,stor,result)

	elseif stat=="LE" then

		handle_LE(cPile,vPile,env,stor,result)

	elseif stat=="GT" then

		handle_GT(cPile,vPile,env,stor,result)

	elseif stat=="GE" then

		handle_GE(cPile,vPile,env,stor,result)

	elseif stat=="AND" then

		handle_AND(cPile,vPile,env,stor,result)

	elseif stat=="OR" then

		handle_OR(cPile,vPile,env,stor,result)

	elseif stat=="NOT" then

		handle_NOT(cPile,vPile,env,stor,result)

	end
]]