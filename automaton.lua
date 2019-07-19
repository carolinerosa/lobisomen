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

local TIMER = 0 


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
	return nil
end

function push(pile,head)

	table.insert(pile,head) --como nao tem valor coloca no final
	--print("tipo: ", type(pile), type(head))
	
end

--[[
function tPrint (table)
	tprint(table,0)
end

function tprint (tbl, indent)
	if not indent then indent = 0 end

	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
			  print(formatting)
			  tprint(v, indent+1)
			else
			  print(formatting .. v)
			end
		  end
	else
		print("<<",tbl,">>")
	end

end
]]

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
		io.write("<<",myTable,">>")	
	end
end


function printStorEnv(stor,env)
	io.write("Env\t: {")
	locID={}--usando o LOC salvarah o valor da  ID

	for id,loc in pairs(env)do
		io.write("[",id,"]=")
		tPrint(loc)
		io.write(",")
		print()
		if getStatement(loc) == "LOC" then 
			locID[getValue(loc)]=id
		end
	end
	print("}")
	
	io.write("Stor\t: {")
	for loca,val in pairs(stor)do


		if(tLen(locID)==0)then
			io.write("")
		elseif (loca <= tLen(env))then
			if locID[loca] ~= nil then 
				io.write("[",locID[loca],"]=")
				tPrint(val)
				io.write(",")
			else
				io.write("[<",loca,">]=")
				tPrint(val)
				io.write(",")
			end
			--print()
		end
	end
	print("}")

end


function printAutomaton(head,cPile,vPile,env,stor,bLocs)
	print("=========================================================================================================================")

	io.write("Head\t: ")
	tPrint(head)
	print("")
	io.write("cPile\t: ")
	tPrint(cPile)
	print("")
	io.write("vPile\t: ")
	tPrint(vPile)
	print("")

	--printStorEnv(stor,env)
	
	io.write("Env\t: {")
	for i,v in pairs(env) do io.write("[",i,"]->") tPrint(v) print(",") end
	print("}")
	io.write("Stor\t: {")
	for i,v in pairs(stor) do io.write("[",i,"]->") tPrint(v) print(",") end
	print("}")

	io.write("bLocs\t: ")
	tPrint(bLocs)
	print("")

	print("=========================================================================================================================")
end


function getLocalization() --por enquanto sempre coloca no final do stor 
	location = loc.getLoc()
	--print("LOCALIZATION IS : " ,location)
	return location
end

function getValue(head) --NUM,BOO,ID,LOC
	category = head[1]
	--print("ESSA EH A  CATEGORIA PEGA",category)
	value = head[2]
	--print("ESSE EH O VALOR",value)
	if category == "NUM" then
		return value
	elseif category == "BOO" then
		if value == "TRUE" then
			value = true
			return value
		elseif value == "FALSE" then
			value = false
			return value
		else
			print("Erro em valor de Booleana")
		end
	elseif category == "ID" then
		return value
	elseif category == "ENV" then
		return value
	elseif category == "LOC" then
		return value	
	elseif category == "ENV" then
		return value  
	end

	print("Eh de um tipo nao implementado ou com erro")
end

function getStatement(head)
	return head[1]
end

function getFirst(head) --{"Category",value1,value2,value3}

	return head[2]
end

function getSecond(head)  --{"Category",value1,value2,value3}

	return head[3]
end

function getThird(head)  --{"Category",value1,value2,value3}

	return head[4]	
end

function makeNode(value,category)
	node = {category,value}
	return node
end

function typeCheck(left,right)
	if getStatement(left)==getStatement(right) then
		return true	
	end
	return false
end


function handle_NUM(head,cPile,vPile,env,stor,bLocs)
	push(vPile,head)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_SUM(head,cPile,vPile,env,stor,bLocs)
	OP = {"#SUM"}
	a = getFirst(head)
	b = getSecond(head)
	push(cPile,OP)
	push(cPile,b)
	push(cPile,a)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_SUM(head,cPile,vPile,env,stor,bLocs)--#SUM , soma dos dois primeiros itens em vPile
	b = pop(vPile)
	a = pop(vPile)

	if not typeCheck(a,b) then
		print("HOUVE UM ERRO! Tipos incompativeis!")
		return
	end

	valueB = getValue(b)
	valueA = getValue(a)


	result = valueA + valueB
	node= makeNode(result,"NUM")

	push(vPile,node)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_SUB(head,cPile,vPile,env,stor,bLocs)
	OP = {"#SUB"}
	a = getFirst(head)
	b = getSecond(head)
	push(cPile,OP)
	push(cPile,b)
	push(cPile,a)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_SUB(head,cPile,vPile,env,stor,bLocs)
	b = pop(vPile)
	a = pop(vPile)

	if not typeCheck(a,b) then
		print("HOUVE UM ERRO! Tipos incompativeis!")
		return
	end

	valueB = getValue(b)
	valueA = getValue(a)

	result = valueA - valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_MUL(head,cPile,vPile,env,stor,bLocs)
	OP = {"#MUL"}
	a = getFirst(head)
	b = getSecond(head)
	push(cPile,OP)
	push(cPile,b)
	push(cPile,a)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_MUL(head,cPile,vPile,env,stor,bLocs)
	b = pop(vPile)
	a = pop(vPile)

	if not typeCheck(a,b) then
		print("HOUVE UM ERRO! Tipos incompativeis!")
		return
	end

	valueB = getValue(b)
	valueA = getValue(a)

	result = valueA * valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_DIV(head,cPile,vPile,env,stor,bLocs)
	OP = {"#DIV"}
	a = getFirst(head)
	b = getSecond(head)
	push(cPile,OP)
	push(cPile,b)
	push(cPile,a)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_DIV(head,cPile,vPile,env,stor,bLocs)
	b = pop(vPile)
	a = pop(vPile)

	if not typeCheck(a,b) then
		print("HOUVE UM ERRO! Tipos incompativeis!")
		return
	end

	if valueB == 0 then
		print("Nao se pode dividir por 0")
	end 

	valueB = getValue(b)
	valueA = getValue(a)

	result = valueA / valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_EQ(head,cPile,vPile,env,stor,bLocs)
	OP = {"#EQ"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_EQ(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA == valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_LT(head,cPile,vPile,env,stor,bLocs)
	OP = {"#LT"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_LT(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA < valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_LE(head,cPile,vPile,env,stor,bLocs)
	OP = {"#LE"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_LE(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	

	if valueA <= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_GT(head,cPile,vPile,env,stor,bLocs)
	OP = {"#GT"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueA)
	push(cPile,valueB)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_GT(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA > valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_GE(head,cPile,vPile,env,stor,bLocs)
	OP = {"#GE"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_GE(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA >= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_BOO(head,cPile,vPile,env,stor,bLocs)
	push(vPile,head)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_AND(head,cPile,vPile,env,stor,bLocs)
	OP = {"#AND"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_AND(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA and valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_OR(head,cPile,vPile,env,stor,bLocs)
	OP = {"#OR"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_OR(head,cPile,vPile,env,stor,bLocs)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA or valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_NOT(head,cPile,vPile,env,stor,bLocs)
	OP = {"#NOT"}
	valueA = getFirst(head)
	push(cPile,OP)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_NOT(head,cPile,vPile,env,stor,bLocs)
	value = getValue(pop(vPile)) --nesse caso apenas um valor
	if value then
		result="FALSE"
	else
		result="TRUE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_LOOP(head,cPile,vPile,env,stor,bLocs)
	OP={"#LOOP"}
	booExp= getFirst(head)

	push(vPile,head) 		--vai no vPile mesmo

	push(cPile,OP)
	push(cPile,booExp)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_LOOP(head,cPile,vPile,env,stor,bLocs)
	booValue= getValue(pop(vPile))
	loop = pop(vPile)

	if booValue then
		command = getSecond(loop)
		push(cPile,loop)
		push(cPile,command)
	end

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_COND(head,cPile,vPile,env,stor,bLocs)
	OP={"#COND"}
	booExp= getFirst(head)

	push(vPile,head) 

	push(cPile,OP)
	push(cPile,booExp)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_COND(head,cPile,vPile,env,stor,bLocs)
	booValue= getValue(pop(vPile))
	cond = pop(vPile)
	if booValue then --Pega o comando 1 ou o 2 
		command = getSecond(cond)
		push(cPile,command)
	else
		command = getThird(cond)
		push(cPile,command)
	end
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_ID(head,cPile,vPile,env,stor,bLocs)
	idValue = getValue(head)
	idValue = idValue:gsub("%s", "")

	coisa = env[idValue]

	if getStatement(coisa) == "LOC" then
		headLoc = getValue(coisa)

		headBindded = stor[headLoc] 

		push(vPile,headBindded)
	else
		push(vPile,coisa)
	end 

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_ASSIGN(head,cPile,vPile,env,stor,bLocs)
	OP = {"#ASSIGN"}
	id = getFirst(head)
	exp = getSecond(head)

	push(vPile,id)

	push(cPile,OP)	
	push(cPile,exp)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_ASSIGN(head,cPile,vPile,env,stor,bLocs)
	expValue = pop(vPile) 
	id=pop(vPile)
	idValue = getValue(id)
	idValue = idValue:gsub("%s", "")
	
	localization = getValue(env[idValue])

	stor[localization] = expValue												

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_CSEQ(head,cPile,vPile,env,stor,bLocs)
	command1 = getFirst(head)
	command2 = getSecond(head)
	push(cPile,command2)
	push(cPile,command1)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

------------------------------Parte 2------------------------------------------

function handle_REF(head,cPile,vPile,env,stor,bLocs)
	OP = {"#REF"}
	exp = getFirst(head)

	push(cPile,OP)
	push(cPile,exp)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_REF(head,cPile,vPile,env,stor,bLocs)

	locValue = getLocalization()	--valor da location em  si,sendo criado
	locVar = loc.makeLoc(locValue)	--{"LOC",locValue}, nosso formato de Location

	expResp = pop(vPile)			--Pegamos o  resultado da expressao colocada pelo REF

	stor[locValue] = expResp		--E a salvamos na memoria, ligada pela nova location
	
	push(bLocs,locVar) 				--Atualizando o Bloco de Locations com a locaion nova

	push(vPile,locVar)				--Empilhamos uma Localization na pilhade valores

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_DEREF(head,cPile,vPile,env,stor,bLocs)
	id=getFirst(head)
	idvalue=getValue(id)

	envData=env[idValue] 			--nao pegamos o valor pois devolve no formato que estiver, usualmente  LOC
	push(vPile,envData)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_VALREF(head,cPile,vPile,env,stor,bLocs)
	id=getFirst(head)
	idvalue=getValue(id)

	envVal=getValue(env[idValue]) 	--Nesses dois abaixo temos que pegar o valor contido no lugar para ele poder ser usado como referencia
	storVal=getValue(stor[envVal])
	storData=stor[storVal] 			--equivale a stor[stor[env[idvalue]]]

	push(vPile,storData)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_BIND(head,cPile,vPile,env,stor,bLocs)
	OP = {"#BIND"}
	id = getFirst(head)
	exp = getSecond(head)

	push(vPile,id)

	push(cPile, OP)
	push(cPile,exp)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_BIND(head,cPile,vPile,env,stor,bLocs)
	--δ(#BIND :: C, B :: W :: V, E, S, L) = δ(C, [W ↦ B] :: V, E, S, L), 
	bindable = pop(vPile)			--Este usualmente serah uma location que o REF terah deixado
	id = pop(vPile)
	H = pop(vPile)
	newEnv = {}						--Onde criaremos um enviroment novo ou uniremos ENVs

	if (H==nil) then 						
		newEnv = {"ENV",{[getValue(id)]=bindable}} 
	elseif (tLen(H)==0) then
		push(vPile,H) 
		newEnv = {"ENV",{[getValue(id)]=bindable}} 	
	elseif  (getStatement(H) ~="ENV") then
		push(vPile,H) 						
		newEnv = {"ENV",{[getValue(id)]=bindable}}
	else
		--O codigo eh o mesmo que  isso -> H[2][getValue(id)] = bindable  , amas assim eh feio 
		tempEnv = getValue(H)  				--se ja tem uma ENV ela pega o {"ENV", {...}}, porem como usamos getValue, tamo devolvendo o		
		tempEnv[getValue(id)] = bindable 	--Atualizamos a table naquela posicao	
		newEnv = {"ENV",tempEnv}		 	--Criamos no formato {"ENV", {...}} , para manter conscistencia 
	end

	push(vPile,newEnv)				--entao este eh empilhado na pilha de valores para  ser usado pelo BLK

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_BLK(head,cPile,vPile,env,stor,bLocs)
	--δ(Blk(D, M) :: C, V, E, S, L) = δ(D :: #BLKDEC :: M :: #BLKCMD :: C, L :: V, E, S, ∅),
	OPdec = {"#BLKDEC"}
	OPcmd = {"#BLKCMD"}
	dec = getFirst(head)
	cmd = getSecond(head)
	
	push(cPile,OPcmd)		--Empilhando  #BLKCMD e M
	push(cPile,cmd)
	
	push(cPile,OPdec)		--Empilhando  #BLKDEC e D
	push(cPile,dec)

	--Temos que colocar o conteudo do bLocs no vPile, e depois deixa-lo vazio
	push(vPile,bLocs)
	bLocs = {}

	
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_BLKDEC(head,cPile,vPile,env,stor,bLocs)	--LEMBRE o ENV empilhado ta na forma {"ENV",{<Aqui eh o env de verdade}}, 
		--ou seja, chame getValue na variavel que segurar o env da pilhade valores

	--δ(#BLKDEC :: C, E' :: V, E, S, L) = δ(C, E :: V, E / E', S, L),
	
	newEnv = pop(vPile)

	
	newEnvValue = getValue(newEnv)


	tempCopy={}

	for i,v in pairs(env)do
		tempCopy[i]=v
	end

	envCopy = {"ENV",tempCopy}
	push(vPile,envCopy)
	
	for newId,v in pairs(newEnvValue) do
		env[newId]=v
	end


	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function isInbLocs(loc,bLocs) --loc 

	for index,locationInbLocs in pairs(bLocs) do
		if getValue(locationInbLocs) == loc then --se o valor  da location atualde bLocs, eh igual a loc
			return true
		end
	end

	return false
end

function handle_H_BLKCMD(head,cPile,vPile,env,stor,bLocs)

	oldEnv = pop(vPile)
	oldbLocs = pop(vPile)


	for i,v in pairs(stor) do 			--note que i eh o valor de uma location
		if isInbLocs(i,bLocs) then 	--se a location nao estiver em bLocs
			stor[i]=nil					--setamos seu valor como nulo (eh a forma de lua limpar memoria)
		end 
	end

	bLocs = oldbLocs


	env = getValue(oldEnv)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_DSEQ(head,cPile,vPile,env,stor,bLocs)
	command1 = getFirst(head)
	command2 = getSecond(head)
	push(cPile,command2)
	push(cPile,command1)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

--------------------------PARTE 3---------------------------------

function handle_ABS(head,cPile,vPile,env,stor,bLocs)
	formals = getFirst(head)
	blk = getSecond(head)

	envCopy = {}
	for i,v in pairs(env) do envCopy[i] = v end  
	envCopy = {"ENV",envCopy}
	closure = {"CLOSURE",formals,blk,envCopy}

	push(vPile,closure)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_CALL(head,cPile,vPile,env,stor,bLocs)
	id = getFirst(head)
	actuals = getSecond(head)

	u = tLen(actuals)
	OPcode = {"#CALL",id,u}
	push(cPile,OPcode)

	for i,x in pairs(actuals) do 
		push(cPile,x)	
	end

	automaton.rec(cPile,vPile,env,stor,bLocs)
end


--[[
function match_aux(f,v,e)
	if (f == {} and v == {})then
		return e 
	else
		envHolder = getFirst(e)
		formalHolder = pop(f)
		valueHolder = pop(v)

		envHolder[formalHolder]=valueHolder

		e = {"ENV", envHolder}

		return match_aux(f,v,e)
	end
end 

function match(f,v)
	respENV = {"ENV",{}}
	if tLen(f) ~= tLen(v) then 
		return respENV
	else
		return match_aux(f,v,respENV)
	end
end]]

function match(f,v)
	respENV = {}
	
	if tLen(f) ~= tLen(v) then
		return {"ENV",{}}
	else
		for index,ID in pairs(f) do 
			idValue = getValue(ID)
			

			respENV[idValue] = v[index]
		end

			resp = {"ENV",respENV}
		return resp
	end
end

function overrideTables(t1,t2)

	if (tLen(t2) ~= 0) then
		for i,v in pairs(t2)do
			t1[i]=v
		end
	end

	return t1
end

function handle_H_CALL(head,cPile,vPile,env,stor,bLocs) 

	id = getFirst(head)
	idValue = getValue(id)
	u = getSecond(head)

	bLocs = {}

	closure = env[idValue] --que pode ser apenas Closure ou REC
	closureType = getStatement(closure)

	formals = getFirst(closure)
	block = getSecond(closure)
	
	values = {}
	for i=1,u,1 do
		values[i] = pop(vPile) --[V₁, V₂, ..., Vᵤ]
	end 

	--O que precisa ser empilhado em caso de CLOSURE e de REC

	envCopy = {}
	for i,v in pairs(env) do envCopy[i] = v end  

	E = envCopy
	E[idValue] = closure   -- E = {I ↦ Closure(F, B, E₁)} ∪ E₂  ou  E = {I ↦ Rec(F, B, E₁, E₂)} ∪ E₃
	Eformatted = {"ENV",E}

	OPcode = {"#BLKCMD"}

	push(cPile,OPcode) --𝛅(B :: #BLKCMD :: C, E :: V, E', S, L), 
	push(cPile,block)
	push(vPile,bLocs)
	push(vPile,Eformatted)

	bLocs={}

	--Criando o novo enviroment E'

	matched = match(formals,values) --match(F, [V₁, V₂, ..., Vᵤ])

	--ATEH AQUI PARECE CORRETO

	Elinha = {}


	if (closureType == "CLOSURE") then
		--E'= E / E₁ / match(F, [V₁, V₂, ..., Vᵤ])
		E1 = getValue(closure[4])

		Elinha = overrideTables(E,E1)
		Elinha = overrideTables(Elinha,getValue(matched))

	elseif (closureType == "REC") then -- nao terminado
		--E' = E / E₁ / unfold(E₂) / match(F, [V₁, V₂, ..., Vᵤ]).
		En1 = getValue(closure[4])
		En2 = closure[5]
		unfoldedE2 = getValue(unfold(En2))

		Elinha = overrideTables(E,En1)
		Elinha = overrideTables(Elinha,unfoldedE2)
		Elinha = overrideTables(Elinha,getValue(matched))
	else 
		print("Erro. Esperado um tipo de Closure")
	end 

	env = Elinha --𝛅(B :: #BLKCMD :: C, E :: V, E', S, L), 
	
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function unfold(enviroment)
	e = getValue(enviroment)

	return reclose(e)
end

function reclose(e)--Unfold Recebe uma ENV e retorna uma ENV. {"ENV", {...}} -> {"ENV", {...}}

	if tLen(e) == 0 then --recloseₑ(∅) = ∅.
		return nil
	elseif tLen(e) > 1 then -- recloseₑ(e₁ ∪ e₂) = recloseₑ(e₁) ∪ recloseₑ(e₂),
		respENV = {}

		for i,v in pairs(e)do
			tempENV = {[i]=v}
			tempENV = reclose(tempENV)

			respENV[i] = getValue(tempENV)
		end

		respENV = {"ENV", respENV} 

		return respENV
	else
		eCopy={}
		for i,v in pairs(e) do eCopy[i]=v end
		tempENV= {"ENV",eCopy} --isso eh o e 
	

		for i,v in pairs(e)do --Sempre eh executado apenas uma vez
			closureType = getStatement(v)

			if closureType == "CLOSURE"then --recloseₑ(I ↦ Closure(F, B, E′)) = (I ↦ Rec(F, B, E′, e)),
				F = v[2]
				B = v[3]
				E1 = v[4]


				respENV = {"ENV",{[i]={"REC",F,B,E1,tempENV}}}
			
				return respENV
			elseif closureType == "REC"then --recloseₑ(I ↦ Rec(F, B, E′, E′′)) = (I ↦ Rec(F, B, E′, e)),
				F = v[2]
				B = v[3]
				E1 = v[4]


				respENV = {"ENV", {[i]={"REC",F,B,E1,tempENV}} }

				return respENV --recloseₑ(I ↦ v) = (I ↦ v) if v ≠ Closure(F, B, E),
			else
				--nop
			end

			return tempENV
		end
	end
end

function handle_RBND(head,cPile,vPile,env,stor,bLocs)
	--𝛅(Rbnd(I, Abs(F, B)) :: C, V, E, S, L) = 𝛅(C, unfold(I ↦ Closure(F, B, E)) :: V, E, S, L),
	id = getFirst(head)
	abs = getSecond(head)
	envCopy = {}
	for i,v in pairs(env) do envCopy[i] = v end  

	envCopy = {"ENV",envCopy}

	closure = {"CLOSURE",getFirst(abs),getSecond(abs),envCopy}
	foldedENV = {"ENV", {[getValue(id)]=closure} }

	unfoldedENV = unfold(foldedENV)

	push(vPile,unfoldedENV)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_NOP(head,cPile,vPile,env,stor,bLocs)
	automaton.rec(cPile,vPile,env,stor,bLocs)
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
        ["CSEQ"]=handle_CSEQ,
        --Parte 2
        ["REF"]=handle_REF,
        ["#REF"]=handle_H_REF,
        ["DEREF"]=handle_DEREF,
        ["VALREF"]=handle_VALREF,
        ["BIND"]=handle_BIND,
        ["#BIND"]=handle_H_BIND,
        ["BLK"]=handle_BLK,
        ["#BLKDEC"]=handle_H_BLKDEC,
        ["#BLKCMD"]=handle_H_BLKCMD,
		["DSEQ"]=handle_DSEQ,
		--Parte 3
		["ABS"]=handle_ABS,
		["CALL"]=handle_CALL,
		["#CALL"]=handle_H_CALL,
		["RBND"]=handle_RBND,
		["NOP"]=handle_NOP
    }

--Funcao recursiva simples que apenas ve o que eh pedido e envia para outra funcao
function automaton.rec(cPile,vPile,env,stor,bLocs)
	if tLen(cPile) == 0 then  

		head = {}--apenas limpando o Head para a impressao do resultado.
		print("O resultado foi : ")
		printAutomaton(head,cPile,vPile,env,stor,bLocs)

		return
	else 
		
		head = pop(cPile)
		
		--O print abaixo eh o que fica sendo ocorrendo a cada interacao 
		printAutomaton(head,cPile,vPile,env,stor,bLocs)

		stat=getStatement(head) --stat para statement, pois pode  ser operacao ou comando

		--TIMER = TIMER + 1 

		if TIMER < 20 then
			handlers[stat](head,cPile,vPile,env,stor,bLocs)
		end
 
	end

	return
end

function automaton.auto(tree)

	cPile={} 	--control pile
	vPile={} 	--value pile
	env={} 	 	--enviroment
	stor={}   	--storage
	bLocs={} 	--Block Locations
	--print={} 	--Print List
	loc.init() 	--inicializando o loc 
	
	--print("tipo: ", type(tree), type(cPile))n

	--tPrint(tree)

	push(cPile,tree)

	automaton.rec(cPile,vPile,env,stor,bLocs)

end

return automaton


