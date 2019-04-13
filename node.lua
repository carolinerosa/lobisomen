
local node = {} --criando modulo


 -- simples iniciacao
function node.init(token)
	return {token=token,children={}}
end


function node.addChild(dadNode,sonNode)
	table.insert(dadNode.children,sonNode)
end

function node.removeChild(dadNode,index)
	table.insert(dadNode.children,index)
end
 
--retorna a tabela de nodes de filhos
function node.getChildren(dadNode)
	return dadNode.children
end

--retorna o node de um filho especifico
function node.getChild(dadNode,index)
	return dadNode.children[index]
end

 --Retornar o numero de filhos
function node.numbChildren(dadNode)
	return #dadNode.children
end

 --Imprime uma lista de todos os filhos de um determinado node
function node.listChildren(dadNode)
	for k,v in pairs(dadNode.children) do
		io.write(v.token,"|") 
	end
	print()
end

--Aplicar umaFuncao em cima de  todos os filhos. podemos passar funcoes direetamente como parametros. Exemplo na parte comentada
function node.funcChildren(dadNode,FUNC)  
	if(dadNode.children ~= {})then
		for k,v in pairs(dadNode.children) do
			FUNC(v)
		end
	end
end

--Faz impressao completa daarvore (bem simples nao fica muito vizivel mas vemoso que tem na arvore)
function node.print(dadNode)
	print(dadNode.token)
	node.funcChildren(dadNode,node.print)  --exemplo de passando funcao como parametro
end


--[[Descomente caso queira fazer testes, ou observar resultados

base = node.init("1")
galho = node.init("2")
gaga = node.init("3")
vivi = node.init("4")

node.addChild(base,galho)
node.addChild(base,gaga)
node.addChild(gaga,vivi)

node.funcChildren(base,node.listChildren) --exemplo de passando funcao como parametro

node.print(base)]]



return node