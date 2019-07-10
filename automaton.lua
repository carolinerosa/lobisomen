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
	return nil
end

function push(pile,head)

	table.insert(pile,head) --como nao tem valor coloca no final
	--print("tipo: ", type(pile), type(head))
	
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

function printStorEnv(stor,env)
	io.write("Env\t: {")
	locID={}--usando o LOC salvarah o valor da  ID

	for id,loc in pairs(env)do
		io.write("[",id,"]=")
		tPrint(loc)
		io.write(",")
		locID[getValue(loc)]=id
		
			
	end
	print("}")
	
	io.write("Stor\t: {")
	for loc,val in pairs(stor)do
		if(tLen(locID)==0)then
			io.write("")
		elseif (loc <= tLen(env))then
			io.write("[",locID[loc],"]=")
			tPrint(val)
			io.write(",")
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

	printStorEnv(stor,env)
	--[[
	io.write("Env\t: ")
	tPrint(env)
	print("")
	io.write("Stor\t: ")
	tPrint(stor)
	print("")]]

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
	
	headLoc = getValue(env[idValue])


	headBindded = stor[headLoc] 
	push(vPile,headBindded)
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
	newEnv = {}								--Onde criaremos um enviroment novo ou uniremos ENVs

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
	
	for newId,newValue in pairs(newEnvValue) do
		env[newId]=newValue
	end


	if(tLen(env)==0) then
		env = newEnvValue	
	end
	--O E' representado ai era pra falar de uma lista de mapas, mas como nao teremosuma varias declaracoes, teremos apenas 1 mapa
	--Este mapa eh deixado pelo BIND,
	--Temos que pegar o enviroment na pilha de valores e entao fazer E/E' que no caso soh significa pegar o mapa e atualizar o E
	--Note o mapa esta no formato {"ENV",id,loc}, usamos o valor de id para indexar o loc (lembre de usar o getValue,getFirst e getSecond)

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

	--δ(#BLKCMD :: C, E :: L :: V, E', S, L') = δ(C, V, E, S', L), where S' = S / L.
	--Note que temos um E e um  L  na  pilha de valores, 
	--O L foi colocado pelo handle_BLK, para voltarmos ao contexto  antes  do bloco ser iniciado
	--O E foi colocado pelo handle_H_BLKDEC, para tambemvoltarmoso  ambiente para o que ele era antes
	--Temos que desempilhar L e E
	--Atualizar bLocs de L' para L
	--E por ultimo algo que passe pelo store e cheque se o index do stor equivale ao valor de um dos locs em L
	--Ex : stor[1]="bola" stor[2]="figo" stor[3]="cabra" stor[4]="bala"  L={1,2,3} (lembrando que nao sao numerosapenas mas {"LOC",<valor>},entao getValue)
	--     S' deve ser : stor[1]="bola" stor[2]="figo" stor[3]="cabra".
	--Lembre-se  que temor for i,v in pairs(mytable) do  , onde o i eh o index e v eh o valor, isso facilita

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_DSEQ(head,cPile,vPile,env,stor,bLocs)
	command1 = getFirst(head)
	command2 = getSecond(head)
	push(cPile,command2)
	push(cPile,command1)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_ABS(head,cPile,vPile,env,stor,bLocs)
	formals = getFirst(head)
	blk = getSecond(head)

	closure = {"CLOSURE",formals,blk,env}

	push(vPile,closure)

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_CALL(head,cPile,vPile,env,stor,bLocs)
	id = getFirst(head)
	formals = getSecond(head)

	u = tLen(formals)
	OPcode = {"#CALL",id,u}
	push(cPile,OPcode)

	for i,x in pairs(formals) do 
		push(cPile,x)	
	end

	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_H_CALL(head,cPile,vPile,env,stor,bLocs)
	automaton.rec(cPile,vPile,env,stor,bLocs)
end

function handle_RBND(head,cPile,vPile,env,stor,bLocs)
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
		
		handlers[stat](head,cPile,vPile,env,stor,bLocs)
 
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

FAC = {"BLK",{"BIND",{"ID","z"},{"REF",{"NUM",1}}},
		{"BLK",{"RBND",{"ID","FAT"},
						{"ABS",{"ID","y"},
							{"BLK",{"BIND",{"ID","x"},{"REF",{"ID","y"}}},
								{"CSEQ",
									{"COND",{"GT",{"ID","x"},{"NUM",2}},
											{"ASSIGN",{"ID","z"},
												{"CALL",{"ID","FAT"},
													{"SUB",{"ID","x"},{"NUM",1}}
												}
											},
											{"NOP"}
									},
									{"ASSIGN",{"ID","x"},{"MUL",{"ID","x"},{"ID","z"}}}
								}
							}											
						}
				},
				{"CALL",{"ID","FAT"},{"NUM",3}}
		}
}
automaton.auto(FAC)

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
exTree19 = {"CSEQ", exTree13 , {"LOOP", {"GT",{"ID","bola"},{"NUM",0}} , {"SUB",{"ID","bola"},{"NUM",1}}} }
]]
--[[
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

--automaton.auto(exTree14)
--automaton.auto(exTree15)
--automaton.auto(exTree16)
--automaton.auto(exTree17)
--automaton.auto(exTree18)
--automaton.auto(exTree19)
]]


return automaton
