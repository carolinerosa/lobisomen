lpeg=require "lpeg"

local white = lpeg.S(" \t\r\n") ^ 0

local integer = white * lpeg.R("09") ^ 1 / tonumber
local muldiv = white * lpeg.C(lpeg.S("/*"))
local addsub = white * lpeg.C(lpeg.S("+-"))
local compare = white * lpeg.C(lpeg.S("><"))
local notValue = white * lpeg.C("NOT")
local igual = white * lpeg.C("=")
local atrib = white * (lpeg.C("=") + lpeg.C("AND") + lpeg.C("OR"))
local compareEqual = white * (lpeg.C(">=") + lpeg.C("<="))
local boolValue = white * (lpeg.C("TRUE") + lpeg.C("FALSE"))

local idValue = white * (lpeg.R("az")) ^1 
local assignValue = white * lpeg.C("ASSIGN")
local loopValue = white * lpeg.C("LOOP")
local CSeq = white * lpeg.C("CSeq")


local spc = lpeg.S(" \t\n")^0

local function node(p)
	print("entrou em node")
  return p  / function(left, op, right)
	print("oi", op,left, right)
	if(op==nil and right == nil) then
		if(type(left)=='number')then
			return{"NUM",left}
		else
			return{left}
		end
	end
	if(left == "NOT") then
		return{left,op, right}
	end
    return {op, left, right }
  end
end

local function nodeCmd(p)
	return p / function(op,id,atrib, value)
	print("oi nodeCmd", op, id, atrib, value)
		return{op,id, atrib, value}
		
	end
end

local calculator = lpeg.P({
  "init",
  init = lpeg.V("input") + lpeg.V("cmd"),
  input = lpeg.V("cexp") + lpeg.V("bexp") + lpeg.V("exp"),
  exp =  lpeg.V("term") + lpeg.V("factor") +lpeg.V("aexp") ,
  term =  node((lpeg.V("aexp") * addsub * (lpeg.V("exp")) )),
  factor =node(( lpeg.V("aexp") * muldiv *  (lpeg.V("exp") ) )  ),
  aexp = node( (spc*"(" * lpeg.V("exp") * ")" * spc ) +integer ),
  bexp = node(boolValue +  (lpeg.V("exp") * ( compareEqual+ compare) * lpeg.V("exp"))),
  cexp = node((lpeg.V("bexp") * atrib * lpeg.V("bexp")) + (notValue *(lpeg.V("bexp") + lpeg.V("cexp")))),
  cmd = lpeg.V("assignGr") + lpeg.V("loopGr"),
  assignGr = nodeCmd(assignValue*spc *lpeg.V("idGr") * spc * igual * lpeg.V("input")),
  idGr = node(idValue),
  loopGr = nodeCmd(loopValue * lpeg.V("bexp") * (lpeg.V("exp") + lpeg.V("bexp") + lpeg.V("cmd")))
})

local comands = lpeg.P({
	"cmd",
	cmd = lpeg.V("assignGr") + lpeg.V("loopGr"),
	assignGr =node(idValue * addsub * idValue ),
	loopGr = node (integer * addsub * integer)
})

function generator(s)
	
print((calculator:match(s)))
    for i,v in ipairs(calculator:match(s)) do 
        if (type(v) == 'table') then 
            for t,u in ipairs(v) do
		
		print(t,u) 
	
            end
        else
            print(i,v)
        end
    end
end


expressao = io.stdin:read'*l'
while (expressao~='exit') do
    print("Expressão: ",expressao)
    generator(expressao)
    expressao = io.stdin:read'*l'
end



