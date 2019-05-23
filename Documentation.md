
# Documentação do automato do projeto Lobisomen

## Organização do documento

* (1) Estrutura basica do automato: Inicializacao do automato e seus componentes  
* (2) Funções auxiliares: Funcoes que serao usadas ao longo do codigo do automaton
* (3) Explicação da implementação das funções δ: Breve explicacao da implementacao das funcoes ligadas as suas respectivas funcoes δ 

## 1 - Estrutura Basica do Automato

### 1.1 - automaton.auto
* Primeiramente temos a funcao que eh chamada na main, "automaton.auto".
* Esta ja recebe uma arvore que ja teria passado pelo Lexer,Parser e Transformer.
* Logo se inicia pilhas de controle e de valores, as quais sao Tables porem sao apenas tratadas  se utilizando das funcoes pop e push (ref.2.6)
* Se inicia uma table para o Enviroment e Storage, assim como se seta a Location.size para 0 (ref.1.3), para se comecar em um sistema limpo sem uso anterior.
* Se coloca a arvore na pilha de controle para ela comecar a ser processada,por ultimo o programa automaton.rec (ref.1.2) eh chamado para se comecar o processamento
```
function automaton.auto(tree)

	cPile={} 	--control pile
	vPile={} 	--value pile
	env={} 	 	--enviroment
	stor={}   	--storage
	loc.init() 	--inicializando o loc

	push(cPile,tree)

	automaton.rec(cPile,vPile,env,stor)

end
```
### 1.2 - automaton.rec

* Funcao recursiva que primeiramente se pega o head da pilha de controle, pega o statement contido neste, ou seja, uma denominacao da primeira funcao δ que deve ser executada.
* Dado o statement pego se serah escolhido uma funcao para ser executada, a qual indicarah qual funcao δ serah tratada.
* Esta recursao termina quando a pilha de controle esta vazia, que indica que ela nao tem mais o que executar. Com uma execucao bem sucedida, seguindo a gramatica π, a pilha de valores tambem estarah vazia, pois terah sido consumida. Porem nao se eh tratado caso termine a execucao com algo na pilha de valores, para permitir programas como o que seria uma calculadora, ou seja, caso apenas se faca 2 + 2, o programa terminarah com NUM(4) na pilha de valores. 
```
function automaton.rec(cPile,vPile,env,stor)

	if tLen(cPile) == 0 then  

		head = {} --apenas limpando o Head para a impressao do resultado.
		print("O resultado foi : ")
		printAutomaton(head,cPile,vPile,env,stor)

		return
	else 

		head = pop(cPile)

		printAutomaton(head,cPile,vPile,env,stor)

		stat=getStatement(head) --stat para statement, pois pode  ser operacao ou comando

		handlers[stat](head,cPile,vPile,env,stor)
	end

	return
end
```
* Segue a table em que se indexa funcoes que tratam as funcoes δ (Explicadas na parte (3) deste documento). Enquanto o index em si sao strings unicas que sao pegas com a funcao getStatement (ref.2.2)

```
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
```

### 1.3 - localization.lua

* Estancia o que esta contido em localization.lua, e traz  suas funcoes.

```
loc = require "localization" 
```

* 

```
loc = {size=0}

function loc.init()
	loc.size=0 
end

function loc.getLoc()
	loc.size = loc.size + 1
	return loc.size
end

function loc.makeLoc(value)
	return {"LOC",value}
end
```
## 2 - Funções auxiliares

### 2.1 - getValue

* Eh apenas chamada para lidar com os "statements" NUM, BOO, ID e LOC, e de acordo com qual eh retorna seu valor, uma vez que todas sempre terao o formato {(categoria),(valor)} 

```
function getValue(head) --NUM,BOO,ID,LOC
	category = head[1]
	value = head[2]
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
	elseif category == "LOC" then
		return value	 	
	end

	print("Eh de um tipo nao implementado ou com erro")
end
```
### 2.2 - getStatement, getFirst, getSecond, getThird

* Criadas antes da certezada estrutura de dados que seria utilizada, apenas pega os valores em ordem na table.

```
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
```

### 2.3 - makeNode

* Forma um "Node", ou seja, algo que carregue um valor e uma categoria, isto eh, NUM, ID, BOO e LOC.

```
function makeNode(value,category)
	node = {category,value}
	return node
end
```
### 2.4 - getLocalization

* Apenas para ter uma forma generalizada de chamar a funcao que devolve uma nova localizacao, implementada na classe Localization

```
function getLocalization() --por enquanto sempre coloca no final do stor 
	loc.getLoc()
	location = loc.size
	--print("LOCALIZATION IS : " location)
	return location
end
```

### 2.6 - pop e push

```
function pop(pile)
	if next(pile) ~= nil then
		lastIndex = tLen(pile)
		value = pile[lastIndex]
		table.remove(pile,lastIndex)
		return value
	end
end

function push(pile,head)
	table.insert(pile,head) --como nao tem valor coloca no final
end
```

### 2.7 - tLen

* Retorna quantos componentes estao presentes em uma table. Pesquisas apontam que metodos ja implementados na lingua como o # nao eh deterministico, portanto se existe uma table na forma {nil,2,nil}, o retorno pode ser 3 ou 1, dai foi preferivel de utilizar desta funcao.

```
function tLen(T) 
	if T == nil then
		return 0
	else
		local count = 0
		for _ in pairs(T) do count = count + 1 end
		return count
	end
end
```
### 2.8 - tPrint

* Dado uma table ela imprime todo o conteudo de uma table, mesmo que esta contenha uma table dentro dela.

```
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
```

### 2.9 - printAutomaton

* Apenas printa o conteudo do automato, isto eh, o control pile, value pile, enviroment, storage e o head para mostrar o que acabou de sair do control pile e irah ser operado.

```
function printAutomaton(head,cPile,vPile,env,stor)
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
	io.write("Env\t: ")
	tPrint(env)
	print("")
	io.write("Stor\t: ")
	tPrint(stor)
	print("")

	print("=========================================================================================================================")
end
```
## 3 - Explicação da implementação das funções δ

As explicacoes sempre comecarao com a funcao δ escrita como foi descrita no Pi Framework, seguida de uma explicacao e depois o codigo. Note que o "head" carrega o valor que esta no topo da pilha de controle ao inicio da execucao da funcao δ.

### 3.1 - NUM

δ(Num(N) :: C, V, S) = δ(C, N :: V, S)

Apenas empilha Num(N) na pilha de valores

```
function handle_NUM(head,cPile,vPile,env,stor)
	push(vPile,head)
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.2 - SUM

δ(Sum(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #SUM :: C, V, S)

Empilha na pilha de controle #SUM, o E2 e o E1 nesta ordem. 

```
function handle_SUM(head,cPile,vPile,env,stor)
	OP = {"#SUM"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#SUM :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ + N₂ :: V, S)

Pega os dois numeros no topo da pilha de valores e os soma. Depois empilha um NUM(resultado) , contendo a soma de N1 com N2.

```
function handle_H_SUM(head,cPile,vPile,env,stor)--#SUM , soma dos dois primeiros itens em vPile
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))

	result = valueA + valueB
	node= makeNode(result,"NUM")

	push(vPile,node)
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.3 - SUB

δ(Sub(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #SUB :: C, V, S)

Empilha na pilha de controle #SUB, o E2 e o E1 nesta ordem. 

```
function handle_SUB(head,cPile,vPile,env,stor)
	OP = {"#SUB"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#SUB :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ - N₂ :: V, S)

Pega os dois numeros no topo da pilha de valores e os subtrai. Depois empilha um NUM(resultado) , contendo a subtracao de N1 com N2.

```
function handle_H_SUB(head,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA - valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.4 - MUL

δ(Mul(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #MUL :: C, V, S)

Empilha na pilha de controle #MUL, o E2 e o E1 nesta ordem. 

```
function handle_MUL(head,cPile,vPile,env,stor)
	OP = {"#MUL"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```
δ(#MUL :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ * N₂ :: V, S)

Pega os dois numeros no topo da pilha de valores e os multiplica. Depois empilha um NUM(resultado) , contendo a multiplicacao de N1 com N2.

```
function handle_H_MUL(head,cPile,vPile,env,stor)
	valueA = getValue(pop(vPile))
	valueB = getValue(pop(vPile))
	result = valueA * valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.5 - DIV

δ(Div(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #MUL :: C, V, S)

Empilha na pilha de controle #DIV, o E2 e o E1 nesta ordem. 

```
function handle_DIV(head,cPile,vPile,env,stor)
	OP = {"#DIV"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#DIV :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ / N₂ :: V, S) if N₂ ≠ 0

Pega os dois numeros no topo da pilha de valores e os divide. Depois empilha um NUM(resultado) , contendo a divisao de N1 com N2.

```
function handle_H_DIV(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	result = valueA / valueB
	push(vPile,makeNode(result,"NUM"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.6 - EQ

δ(Eq(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #EQ :: C, V, S)

Empilha na pilha de controle #EQ, o E2 e o E1 nesta ordem. 

```
function handle_EQ(head,cPile,vPile,env,stor)
	OP = {"#EQ"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#EQ :: C, Boo(B₁) :: Boo(B₂) :: V, S) = δ(C, B₁ = B₂ :: V, S)

Pega as duas booleanas do topo da pilha de valores e faz uma comparacao entre elas, retornando {"BOO","TRUE"} se o resultado for true, caso contrario retorna {"BOO","FALSE"}  

```
function handle_H_EQ(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA == valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.7 - LT

δ(Lt(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #LT :: C, V, S)

Empilha na pilha de controle #LT, o E2 e o E1 nesta ordem. 

```
function handle_LT(head,cPile,vPile,env,stor)
	OP = {"#LT"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#LT :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ < N₂ :: V, S)

Pega os dois numeros do topo da pilha de valores e faz uma comparacao entre elas, retornando {"BOO","TRUE"} se o resultado for true, caso contrario retorna {"BOO","FALSE"}  

```
function handle_H_LT(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA < valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.8 - LE

δ(Le(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #LE :: C, V, S)

Empilha na pilha de controle #LE, o E2 e o E1 nesta ordem. 

```
function handle_LE(head,cPile,vPile,env,stor)
	OP = {"#LE"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```
δ(#LE :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ ≤ N₂ :: V, S)

Pega os dois numeros do topo da pilha de valores e faz uma comparacao entre elas, retornando {"BOO","TRUE"} se o resultado for true, caso contrario retorna {"BOO","FALSE"}  

```
function handle_H_LE(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA <= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.9 - GT

δ(Gt(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #GT :: C, V, S)

Empilha na pilha de controle #GT, o E2 e o E1 nesta ordem. 

```
function handle_GT(head,cPile,vPile,env,stor)
	OP = {"#GT"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#GT :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ > N₂ :: V, S)

Pega os dois numeros do topo da pilha de valores e faz uma comparacao entre elas, retornando {"BOO","TRUE"} se o resultado for true, caso contrario retorna {"BOO","FALSE"} 

```
function handle_H_GT(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA > valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.10 - GE

δ(Ge(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #GE :: C, V, S)

Empilha na pilha de controle #GE, o E2 e o E1 nesta ordem. 

```
function handle_GE(head,cPile,vPile,env,stor)
	OP = {"#GE"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#GE :: C, Num(N₁) :: Num(N₂) :: V, S) = δ(C, N₁ ≥ N₂ :: V, S)

Pega os dois numeros do topo da pilha de valores e faz uma comparacao entre elas, retornando {"BOO","TRUE"} se o resultado for true, caso contrario retorna {"BOO","FALSE"} 

```
function handle_H_GE(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA >= valueB then 
		result = "TRUE"
	else
		result = "FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.11 BOO

Apesar de nao escrita na documentacao do Pi Framework sua funcao δ eh deduzivel atravez da funcao δ de NUM.

δ(Boo(N) :: C, V, S) = δ(C, N :: V, S)

Apenas empilha um Boo(N) na pilha de valores

```
function handle_BOO(head,cPile,vPile,env,stor)
	push(vPile,head)
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.12 - AND

δ(And(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #AND :: C, V, S)

Empilha na pilha de controle #AND, o E2 e o E1 nesta ordem. 

```
function handle_AND(head,cPile,vPile,env,stor)
	OP = {"#AND"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#AND :: C, Boo(B₁) :: Boo(B₂) :: V, S) = δ(C, B₁ ∧ B₂ :: V, S)

Pega os dois BOO's do topo da pilha de valores e faz a operacao de AND com eles e retorna um "node" {"BOO","TRUE"} ou {"BOO","FALSE"}.

```
function handle_H_AND(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA and valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.13 - OR

δ(Or(E₁, E₂) :: C, V, S) = δ(E₁ :: E₂ :: #OR :: C, V, S)

Empilha na pilha de controle #OR, o E2 e o E1 nesta ordem. 

```
function handle_OR(head,cPile,vPile,env,stor)
	OP = {"#OR"}
	valueA = getFirst(head)
	valueB = getSecond(head)
	push(cPile,OP)
	push(cPile,valueB)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#OR :: C, Boo(B₁) :: Boo(B₂) :: V, S) = δ(C, B₁ ∨ B₂ :: V, S)

Pega os dois BOO's do topo da pilha de valores e faz a operacao de OR com eles e retorna um "node" {"BOO","TRUE"} ou {"BOO","FALSE"}.

```
function handle_H_OR(head,cPile,vPile,env,stor)
	valueB = getValue(pop(vPile))
	valueA = getValue(pop(vPile))
	if valueA or valueB then
		result="TRUE"
	else
		result="FALSE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.14 - NOT

δ(Not(E) :: C, V, S) = δ(E :: #NOT :: C, V, S)

Empilha na pilha de controle #NOT, o OP e o value a ser invertido nesta ordem. 

```
function handle_NOT(head,cPile,vPile,env,stor)
	OP = {"#NOT"}
	valueA = getFirst(head)
	push(cPile,OP)
	push(cPile,valueA)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#NOT :: C, Boo(True) :: V, S) = δ(C, False :: V, S)

δ(#NOT :: C, Boo(False) :: V, S) = δ(C, True :: V, S)

Dado uma booleana se ela for true se retorna false, e se for false a retona true, isto  dentro de um "node" {"BOO",result}

```
function handle_H_NOT(head,cPile,vPile,env,stor)
	value = getValue(pop(vPile)) --nesse caso apenas um valor
	if value then
		result="FALSE"
	else
		result="TRUE"
	end
	push(vPile,makeNode(result,"BOO"))
	automaton.rec(cPile,vPile,env,stor)
end
```


### 3.15 - ASSING

δ(Assign(W, X) :: C, V, E, S) = δ(X :: #ASSIGN :: C, W :: V, E, S'),

O Id eh colocado na pilha de valores, entao se empilham #ASSIGN e em seguida se empilha o valor que serah associado ao Id 

```
function handle_ASSIGN(head,cPile,vPile,env,stor)
	OP = {"#ASSIGN"}
	id = getFirst(head)
	exp = getSecond(head)

	push(vPile,id)

	push(cPile,OP) 		
	push(cPile,exp)

	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#ASSIGN :: C, T :: W :: V, E, S) = δ(C, V, E, S'), where E[W] = l ∧ S' = S/[l ↦ T]

Pega da pilha de valores o Id e seu valor (executando a funcao gsub para tirar espacos possivelmente contidos no Id). Dada a permissao de realizar o Assign de forma a nao se utilizar Ref nem Bind, nos utilizamos da string que eh o valor do Id para indexar a localizacao ligada ao Id. 

Se onde esta indexado nao possuir nenhuma informacao, se gera uma localizacao nova e a salva esta no enviromento, no lugar indexado pelo valor (a string) do Id. 

Note que esta sendo adicionado uma table Loc e ID, este Id nunca eh acessado, uma vez que ele nao faz parte do modelo a ser seguido, ele estah ali apenas a pedido de ter uma impressao na tela mais simpels de ser entendida (uma vez que a impressao imprime todos os valores do enviroment e storage). Caso este Id fosse retirado nada mudaria, novamente, uma vez que este nao eh utlizado na logica de  funcionamento do  automato.

Caso o env[idValue] ja  possuisse um valor associado, pegamos a  location salva neste local e a usamos para achar no storage o index correspondente ao valor da location, e salvamos o valor associado a Id, isto eh, o expValue. Note que em ambos  os casos de termos ou nao uma location associada a aquela  posicao do enviroment, se eh feito este "update" no que se eh salvo pela storage.

```
function handle_H_ASSIGN(head,cPile,vPile,env,stor)
	expValue = pop(vPile) 
	id=pop(vPile)
	idValue = getValue(id)
	idValue = idValue:gsub("%s", "")
	if (env[idValue]==nil) then
		localization = getLocalization() 
		env[idValue] = {loc.makeLoc(localization),id}		
	end
	localization = getValue(env[idValue][1])
	stor[localization] = {expValue,id}
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.16 - ID

δ(Id(W) :: C, V, E, S) = δ(C, B :: V, E, S), where E[W] = l ∧ S[l] = B

Pegamos o valor da Id, executamos uma funcao para assegurarmos que nao existem espacos na nomenclatura desta Id. Em seguida recuperamos o valor da Localizacao que havia sido indexada pelo valor da Id, para entao recuperar oque havia sido salvo na memoria como valor associado ao Id. Por fim colocamos este valor (este sempre sendo um NUM ou BOO, no momento), e o colocamos na pilha de valores.

```
function handle_ID(head,cPile,vPile,env,stor)
	idValue = getValue(head)
	idValue = idValue:gsub("%s", "")
	headLoc = getValue(env[idValue][1])
	headBindded = stor[headLoc][1] 
	push(vPile,headBindded)
	automaton.rec(cPile,vPile,env,stor)
end
```


### 3.17 - LOOP

δ(Loop(X, M) :: C, V, E, S) = δ(X :: #LOOP :: C, Loop(X, M) :: V, E, S),

Pega os X (booExp) que seria a expressao booleana, coloca na pilha de valores todo o loop (que seria o head). Depois empilha na pilha de controle #LOOP e X.

```
function handle_LOOP(head,cPile,vPile,env,stor)
	OP={"#LOOP"}
	booExp= getFirst(head)

	push(vPile,head) 		

	push(cPile,OP)
	push(cPile,booExp)
	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#LOOP :: C, Boo(true) :: Loop(X, M) :: V, E, S) = δ(M :: Loop(X, M) :: C, V, E, S),

δ(#LOOP :: C, Boo(false) :: Loop(X, M) :: V, E, S) = δ(C, V, E, S)

Pega o resultado da expressao booleana (isto eh true ou false) e tambem pega o loop,ambos da pilha de valores. Caso o resultado tenha sido true, entao se pega M (que eh o command no codigo, que eh aquilo que serah executado dentro do Loop), empilha o loop inteiro novamente e em seguida M (para este ser executadono topo da pilha). 

```
function handle_H_LOOP(head,cPile,vPile,env,stor)
	booValue= getValue(pop(vPile))
	loop = pop(vPile)

	if booValue then
		command = getSecond(loop)
		push(cPile,loop)
		push(cPile,command)
	end

	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.18 - COND

δ(Cond(X, M₁, M₂) :: C, V, E, S) = δ(X :: #COND :: C, Cond(X, M₁, M₂) :: V, E, S),

Pega a expressao booleana, se coloca toda a Cond na pilha de valores. Depois se empilha #COND e em cima a expressao booleana para ser processada na pilhade controle.

```
function handle_COND(head,cPile,vPile,env,stor)
	OP={"#COND"}
	booExp= getFirst(head)

	push(vPile,head) 

	push(cPile,OP)
	push(cPile,booExp)

	automaton.rec(cPile,vPile,env,stor)
end
```

δ(#COND :: C, Boo(true) :: Cond(X, M₁, M₂) :: V, E, S) = δ(M₁ :: C, V, E, S),

δ(#COND :: C, Boo(false) :: Cond(X, M₁, M₂) :: V, E, S) = δ(M₂ :: C, V, E, S)

Pega na pilha de valores o resultado da expressao booleana, sendo este true ou false(salvo em booValue). Caso booValue seja true, se empilha na pilha de controle M1 (pego do condicional com getSecond),caso contrario se empilha M2 (pego com getThird).

```
function handle_H_COND(head,cPile,vPile,env,stor)
	booValue= getValue(pop(vPile))
	cond = pop(vPile)
	if booValue then --Pega o comando 1 ou o 2 
		command = getSecond(cond)
		push(cPile,command)
	else
		command = getThird(cond)
		push(cPile,command)
	end
	automaton.rec(cPile,vPile,env,stor)
end
```

### 3.19 - CSEQ

δ(CSeq(M₁, M₂) :: C, V, E, S) = δ(M₁ :: M₂ :: C, V, E, S)

Pega M1 e M2 (chamado no codigo de command1 e command2 respectivamente,porem nao englobando apenas commandos) e os  coloca na pilha de controle.

```
function handle_CSEQ(head,cPile,vPile,env,stor)
	command1 = getFirst(head)
	command2 = getSecond(head)
	push(cPile,command2)
	push(cPile,command1)
	automaton.rec(cPile,vPile,env,stor)
end
```