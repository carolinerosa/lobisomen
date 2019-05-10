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

  return p  / function(left, op, right)
	print("oi", op,left, right)
	print(type(left))
	if( op=="+") then
		op = "SUM"
	end
	if(op =="-") then
		op = "SUB"
	end
	
	if(op == "*") then
		op = "MUL"
	end
	if(op == "/") then
		op = "DIV"
	end

	if(op == ">") then
                op = "GT"
        end
        if(op == "<") then
                op = "LT"
        end
        if(op == ">=") then
                op = "GE"
        end
        if(op == "<=") then
                op = "LE"
        end
	if(op == "=") then
                op = "EQ"
        end
            
	if(left == "TRUE" or left =="FALSE") then
                left = {"BOO",left}
        end

	if(type(left) == 'string')then
		print("e string")
		left={"ID",left}
		 
	end        
	
	print("pos conversao", op, left, right)
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
	if(id =='=') then
		value ="ASSIGN"
		id = {"EQ",id}
		return{value,op,id, atrib }
	end
	if(op=="LOOP") then
		atrib = atrib
		
	end

		return{op,id, atrib, value}
		
	end
end

local calculator = lpeg.P({
  "init",
  init = lpeg.V("input") + lpeg.V("cmd") ,
  input = lpeg.V("cexp") + lpeg.V("bexp") + lpeg.V("exp"),
  exp =  lpeg.V("term") + lpeg.V("factor") +lpeg.V("aexp") ,
  term =  node((lpeg.V("aexp") * addsub * (lpeg.V("exp")) )),
  factor =node(( lpeg.V("aexp") * muldiv *  (lpeg.V("exp") ) )  ),
  aexp = node( (spc*"(" * lpeg.V("exp") * ")" * spc ) +integer ),
  bexp = node(boolValue +  (lpeg.V("exp") * ( compareEqual+ compare) * lpeg.V("exp"))),
  cexp = node((lpeg.V("bexp") * atrib * lpeg.V("bexp")) + (notValue *(lpeg.V("bexp") + lpeg.V("cexp")))),
  cmd = lpeg.V("assignGr") + lpeg.V("loopGr"),
  assignGr = nodeCmd(lpeg.V("idGr") * spc * igual * lpeg.V("input")),
  idGr = node(idValue) ,
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
		if(type(u) == 'table')then
			for y,z in ipairs(u) do
				print(y, z)
			end
		else		
		print(t,u) 
	
		end
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



