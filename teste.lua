--[[

UTILIZEMOS ESTE ARQUIVO PARA  FAZER TODOS OS TESTES, E DEIXAR PARADAS  ANOTADAS
PQ AI VEMOS O QUE O OUTRO TESTO PQ PODE AJUDAR.

EVENTUALMENTE TEREMOS APENAS QUE COMENTAR UNS  PRINTS PQ TEM MUITO ASUHASUHASUHASUH

]]


lexit = require "lexit"  -- Import lexit module

node = require  "node"

lexstr = ""
cat = 0 
sl = {}

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function op(T)
	print("{",T[1],"|",T[2],"}")
end 

temp = {}

for lexstr,cat in lexit.lex("5 * ( 3 + 2 )") do
	--print(lexstr,"|",cat)
	temp = {lexstr,cat}
	--table.insert(sl,lexstr)
	--table.insert(sl,cat)
	--op(temp)
	table.insert(sl,temp)
end

--print(#sl)
--[[
for i=1,(#sl-1),1 do
	io.write(sl[i]," | ")
end
print()
]]

for i=1,#sl,1 do
	op(sl[i])
end
