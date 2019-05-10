--[[

Referencia : https://github.com/ChristianoBraga/PiFramework/blob/master/doc/pi-in-a-nutshell.md

Tipos Basicos 

NUM numero 					{"NUM",<numero>}  | Ex: 3  => {"NUM",3}  | Tanto faz o  tipo do 3,int,float,double,, soh algo que  da pra fazer conta
BOO booleanas 				{"BOO", "TRUE"}  OU {"BOO","FALSE"} , usei Strings em vezdesoh  true  e falsee ja tratei, soh pra tipo nao ter erro de tipo dizer que TRUE e FALSE  sao palavras reservada
ID 	Identificador			{"ID",<nomedo id>} | Ex: bola => {"ID","bola"}

Expressoes aritimeticas
		
SUM soma 					{"SUM", <numero A ou expressao A> , <numero B ou expressao B>} 	| Ex :  2 + 4 ==> {"SUM", {"NUM",2} , {"NUM",4}}     
SUB subtracao				{"SUB", <numero A ou expressao A> , <numero B ou expressao B>}	| Ex :  4 - 1 ==> {"SUB", {"NUM",4} , {"NUM",1}}  
MUL multiplicacao			{"MUL", <numero A ou expressao A> , <numero B ou expressao B>}	| Ex :  9 * 7 ==> {"MUL", {"NUM",9} , {"NUM",7}}  
DIV divisao					{"DIV", <numero A ou expressao A> , <numero B ou expressao B>}	| Ex :  3 / 6 ==> {"DIV", {"NUM",3} , {"NUM",6}}  
EQ  igual					{"EQ", <numero A ou expressao A> , <numero B ou expressao B>}	| Nesse e nos 4 abaixo nao estamos tratando caso  nao seja um numero,o prof falo disso de tipo tratar pra nao deixar entrar aqui
LT  menor que 				{"LT", <numero A ou expressao A> , <numero B ou expressao B>}	| e deixar rolar sabe ? Por enquanto nao ligarmos pra qual "tipo" de info ele quer comparar
LE	menor ou igual			{"LE", <numero A ou expressao A> , <numero B ou expressao B>}	| 
GT 	maior que 				{"GT", <numero A ou expressao A> , <numero B ou expressao B>}	|
GE  maior ou igual 			{"GE", <numero A ou expressao A> , <numero B ou expressao B>}	|

Expressoes booleanas 

AND e 						{"AND", <boolean A ou expressaoBooleana A>, <boolean B ou expressaoBooleana B>} | Ex : TRUE AND 2 > 3  ==> {"AND",{"BOO","TRUE"},{"GT",{"NUM",2},{"NUM",3}}}
OR  ou 						{"OR", <boolean A ou expressaoBooleana A>, <boolean B ou expressaoBooleana B>} 	|
NOT nao 					{"NOT", <boolean A ou expressaoBooleana A>} | Ex: NOT 5 <= 6    ==>  {"NOT", {"LE",5,6}} | acho que tanto faz ficar NOT(5<=6) ou NOT 5<=6, vamos fazer sem parentezes mesmo,mas tanto faz devolve a mesma coisa
 
Comandos

LOOP 						{"LOOP",<expressaoBooleana>,<expressaoBooleana ou aritmetica ou comando>} |Ex: LOOP TRUE 1 + 1 ==> {"LOOP",{"BOO","TRUE"}, {"SUM", 1 , 1} } | EXMaisDificil: LOOP bola > 4 bola + 1  ou LOOP (bola > 4) bola + 1  ==> {"LOOP", {"GT" , {"ID", "bola"} , {"NUM", 4} } , {"SUM", {"ID","bola"}, {"NUM", 1} } } 
COND  						{"COND",<expressaoBooleana>,<expressaoBooleana ou aritmetica ou comando A> , <expressaoBooleana ou aritmetica ou comando B>} | Ex: COND 0 < 1 5+7 3*4 ==> << 0<1=Exp  5+7=A, 3*4=B >>  {"COND", {Exp} , {A} , {B}}
ASSIGN 						{"ASSIGN",<ID>,<expressaoAritmetica ou Booleana ou Num ou Boo>} | Ex: bola = 3  ou bola := 3   (como preferir, da no mesmo pro meu lado)  ==> {"ASSIGN", {"ID", "bola"}, {"NUM",3} } 
CSEQ 						{"CSEQ" , <expressaoBooleana ou aritmetica ou comando A>,<expressaoBooleana ou aritmetica ou comando B>}

]]

loc = require "localization" 

local automaton = {}

function tLen(T) --Prasaber o tamanho da tabela | serio nao use  # nao eh deterministico
	if T == nil then
		return 0
	else
		local count = 0
		for _ in pairs(T) do count = count + 1 end
		return count
	end
end

function pop(pile)
	if next(pile) ~= nil then
		lastIndex = tLen(pile)
		value = pile[lastIndex]
		table.remove(pile,lastIndex)
		return value
	end
end

function push(pile,item)
	table.insert(pile,item) --como nao tem valor coloca no final
end

function tPrint(myTable)
	if myTable==nil then
		io.write("")
	elseif type(myTable) == "table" then
		io.write("{")
		for k,v in pairs(myTable) do
			if type(v) == "table" then
				tPrint(v)
				if k ~= tLen(myTable) then 
					io.write(",")
				end
			else
	    		if k ~= tLen(myTable) then 
					io.write(v,",")
				else 
					io.write(v)
				end
			end
		end
		io.write("}")
	else 
		--io.write(myTable)	
	end
end

function printAutomaton(item,cPile,vPile,env,stor)
	print("=========================================================================================================================")

	io.write("Topo\t: ")
	tPrint(item)
	print("")
	io.write("cPile\t: ")
	tPrint(cPile)
	print("")
	io.write("vPile\t: ")
	tPrint(vPile)
	print("")
	io.write("Env\t: ")
	tPrint(env)
	print("")
	io.write("Stor\t: ")
	tPrint(stor)
	print("")

	print("=========================================================================================================================")
end


function getLocalization() --por enquanto sempre coloca no final do stor 
	loc.getLoc()
	location = loc.size
	--print("LOCALIZATION IS : " location)
	return location
end

function getValue(item) --NUM,BOO,ID,LOC
	category = item[1]
	value = item[2]
	if category == "NUM" then
		return value
	elseif category == "BOO" then
		if value == "TRUE" then
			return true
		elseif value == "FALSE" then
			return false
		else
			print("Erro em valor de Booleana")
		end
	elseif category == "ID" then
		return value
	elseif category == "LOC" then
		return value	 	
	end

end

function getStatement(item)
	return item[1]
end

function getFirst(item) --{"Category",value1,value2,value3}
	return item[2]

end

function getSecond(item)  --{"Category",value1,value2,value3}
	return item[3]
end

function getThird(item)  --{"Category",value1,value2,value3}
	return item[4]
end

function makeNode(value,category)
	node = {category,value}
	return node
end

function handle_NUM(item,cPile,vPile,env,stor)
	push(vPile,item)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_SUM(item,cPile,vPile,env,stor)
	OP = {"#SUM"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_SUM(item,cPile,vPile,env,stor)--#SUM , soma dos dois primeiros itens em vPile
	--vA = pop(vPile)
	--vB = pop(vPile)

	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))

	result = valueA + valueB
	node= makeNode(result,"NUM")

	push(vPile,node)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_SUB(item,cPile,vPile,env,stor)
	OP = {"#SUB"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_SUB(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA - valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_MUL(item,cPile,vPile,env,stor)
	OP = {"#MUL"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_MUL(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA * valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_DIV(item,cPile,vPile,env,stor)
	OP = {"#DIV"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_DIV(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA / valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_EQ(item,cPile,vPile,env,stor)
	OP = {"#EQ"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_EQ(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA == valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_LT(item,cPile,vPile,env,stor)
	OP = {"#LT"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_LT(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA < valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_LE(item,cPile,vPile,env,stor)
	OP = {"#LE"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_LE(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA <= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_GT(item,cPile,vPile,env,stor)
	OP = {"#GT"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_GT(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA > valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_GE(item,cPile,vPile,env,stor)
	OP = {"#GE"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_GE(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA >= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_BOO(item,cPile,vPile,env,stor)
	push(vPile,item)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_AND(item,cPile,vPile,env,stor)
	OP = {"#AND"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_AND(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA and valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end


function handle_OR(item,cPile,vPile,env,stor)
	OP = {"#OR"}
	valueA = getFirst(item)
	valueB = getSecond(item)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_OR(item,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	if valueA or valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end

function handle_NOT(item,cPile,vPile,env,stor)
	OP = {"#NOT"}
	valueA = getFirst(item)
	push(cPile,OP)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_NOT(item,cPile,vPile,env,stor)
	value = getValue(pop(vPile)) --nesse caso apenas um valor
	if value then
		result="FALSE"
	else
		result="TRUE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end


function handle_LOOP(item,cPile,vPile,env,stor)
	OP={"#LOOP"}
	booExp= getFirst(item)

	push(vPile,item) 		--vai no vPile mesmo

	push(cPile,OP)
	push(cPile,booExp)
	automaton.rec(cPile,vPile,env,stor)

end

function handle_H_LOOP(item,cPile,vPile,env,stor)
	booValue= getValue(pop(vPile))
	loop = pop(vPile)
	if booValue then
		command = getSecond(loop)
		push(cPile,loop)
		push(cPile,command)
	end
end

function handle_COND(item,cPile,vPile,env,stor)
	OP={"#COND"}
	booExp= getFirst(item)

	push(vPile,item) 

	push(cPile,OP)
	push(cPile,booExp)

	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_COND(item,cPile,vPile,env,stor)
	booValue= getValue(pop(vPile))
	cond = pop(vPile)
	if booValue then --Pega o comando 1 ou o 2 
		command = getSecond(cond)
		push(cPile,command)
	else
		command = getThird(cond)
		push(cPile,command)
	end
end

function handle_ID(item,cPile,vPile,env,stor)
	idValue = getValue(item)
	itemLoc = getValue(env[idValue][1])
	itemBindded = stor[itemLoc][1] 
	push(vPile,itemBindded)
	automaton.rec(cPile,vPile,env,stor)
end

function handle_ASSIGN(item,cPile,vPile,env,stor)
	OP = {"#ASSIGN"}
	id = getFirst(item)
	exp = getSecond(item)

	push(vPile,id)

	push(cPile,OP) 		
	push(cPile,exp)

	automaton.rec(cPile,vPile,env,stor)
end

function handle_H_ASSIGN(item,cPile,vPile,env,stor)
	expValue = pop(vPile) 
	id=pop(vPile)
	idValue = getValue(id)
	localization = getLocalization() 
	env[idValue] = {loc.makeLoc(localization),id}
	stor[localization] = {expValue,id}
	automaton.rec(cPile,vPile,env,stor)
end

function handle_CSEQ(item,cPile,vPile,env,stor)
	command1 = getFirst(item)
	command2 = getSecond(item)
	push(cPile,command2)
	push(cPile,command1)
	automaton.rec(cPile,vPile,env,stor)
end

handlers =
    {
        ["NUM"]=handle_NUM,
		["BOO"]=handle_BOO,
		["ID"]=handle_ID,
        ["SUM"]=handle_SUM,
        ["#SUM"]=handle_H_SUM,
        ["SUB"]=handle_SUB,
        ["#SUB"]=handle_H_SUB,
        ["MUL"]=handle_MUL,
        ["#MUL"]=handle_H_MUL,
        ["DIV"]=handle_DIV,
        ["#DIV"]=handle_H_DIV,
        ["EQ"]=handle_EQ,
        ["#EQ"]=handle_H_EQ,
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
        ["LOOP"]=handle_LOOP,
        ["#LOOP"]=handle_H_LOOP,
        ["COND"]=handle_COND,
        ["#COND"]=handle_H_COND,
        ["ASSIGN"]=handle_ASSIGN,
        ["#ASSIGN"]=handle_H_ASSIGN,
        ["CSEQ"]=handle_CSEQ
    }

--Funcao recursiva simples que apenas ve o que eh pedido e envia para outra funcao
function automaton.rec(cPile,vPile,env,stor)
	if tLen(cPile) == 0 then

		--Comente para a apresentacao
		print("O resultado foi : ")
		printAutomaton(item,cPile,vPile,env,stor)

		return {vPile,stor}
	else 

		item = pop(cPile)

		--Comente para a apresentacao
		printAutomaton(item,cPile,vPile,env,stor)


		stat=getStatement(item) --stat para statement, pois pode  ser operacao ou comando

		handlers[stat](item,cPile,vPile,env,stor)
	end

	return {vPile,stor}
end

function automaton.auto(tree)

	cPile={} 	--control pile
	vPile={} 	--value pile
	env={} 	 	--enviroment
	stor={}   	--storage
	--loc.init() 	--inicializando o loc para cada programa, soh comentar caso nao queira resetar ele 

	push(cPile,tree)

	result = automaton.rec(cPile,vPile,env,stor)

	finalVPile =  result[1]
	finalStor = result[2]

	--Impressao bonitinha de teoricamente o que tinhamos que exibir. Recomendo comentar caso vah se utilizar das outras visualizacoes
	--[[
	print("\n O estado final da Pilha de  valores  foi:")
	tPrint(finalVPile)
	print("\n\n O estado final da Memoria foi: ")
	tPrint(finalStor)
	print()
	]]

end


--Testes podem ser feitos sem o parser

--[[ 
exTree1 = {"SUM",{"NUM",6},{"NUM",2}}
exTree2 = {"SUB",{"NUM",6},{"NUM",2}}
exTree3 = {"MUL",{"NUM",6},{"NUM",2}}
exTree4 = {"DIV",{"NUM",6},{"NUM",2}}
exTree5 = {"EQ",{"NUM",4},{"NUM",3}}
exTree6 = {"LT",{"NUM",4},{"NUM",3}}
exTree7 = {"LE",{"NUM",4},{"NUM",3}}
exTree8 = {"GT",{"NUM",4},{"NUM",3}}
exTree9 = {"GE",{"NUM",4},{"NUM",3}}
exTree10 = {"AND",{"BOO","TRUE"},{"GT",{"NUM",4},{"NUM",3}}}
exTree11 = {"OR",{"BOO","TRUE"},{"GT",{"NUM",4},{"NUM",3}}}
exTree12 = {"NOT", {"LE",{"NUM",5},{"NUM",6}}} 
exTree13 = {"ASSIGN", {"ID", "bola"}, {"NUM",3}} 
exTree14 = {"COND", exTree10 , exTree1 , exTree3 }
exTree15 = {"LOOP", exTree11 , exTree3}
exTree16 = {"CSEQ", exTree13 , {"SUM",{"ID","bola"},{"NUM",2}} }
exTree17 = {"AND",{"BOO","TRUE"},{"NUM",3}}
exTree18 = {"CSEQ", {"ASSIGN", {"ID", "bola"}, {"NUM",3}}  , {"ASSIGN", {"ID", "ogro"}, {"NUM",7}} }


automaton.auto(exTree1)
automaton.auto(exTree2)
automaton.auto(exTree3)
automaton.auto(exTree4)
automaton.auto(exTree5)
automaton.auto(exTree6)
automaton.auto(exTree7)
automaton.auto(exTree8)
automaton.auto(exTree9)
automaton.auto(exTree10)
automaton.auto(exTree11)
automaton.auto(exTree12)
automaton.auto(exTree13)
automaton.auto(exTree14)
automaton.auto(exTree15)
automaton.auto(exTree16)
automaton.auto(exTree17)
automaton.auto(exTree18)
]]

return automaton