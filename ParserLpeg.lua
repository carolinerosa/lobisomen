lpeg=require "lpeg"


parse = {}

local white = lpeg.S(" \t\r\n") ^ 0


--[[ regras basicas gramatica --]]
local integer = white * lpeg.R("09") ^ 1 / tonumber
local multDivValue = white * lpeg.C(lpeg.S("/*"))
local addSubValue = white * lpeg.C(lpeg.S("+-"))
local notValue = white * lpeg.C("Not")
local igual = white * lpeg.C(":=")
local compare = white * lpeg.C("==")
local andOr = white * (lpeg.C("and") + lpeg.C("or"))
local compareEqual = white * (lpeg.C(">=") + lpeg.C("<=") + lpeg.C(lpeg.S("><")))
local boolValue = white * (lpeg.C("True") + lpeg.C("False"))


--[[regras para id e comandos --]]
local idValue = white * (lpeg.R("az")) ^1 
local loopValue = white * lpeg.C("while")
local condValue = white * lpeg.C("if")
local elseValue = white * lpeg.C("else")
local spc = lpeg.S(" \t\n")^0

function typeSum()
	return "SUM"
end

function typeSub()
	return "SUB"
end

function typeMul()
	return "MUL"
end

function typeDiv()
	return "DIV"
end

function typeGT()
	return "GT"
end

function typeLT()
	return "LT"
end

function typeGE()
	return "GE"
end

function typeLE()
	return "LE"
end

function typeEQ()
	return "EQ"
end

function typeAssign()
	return "ASSIGN"
end

function typeWhile(left, op, right, ...)
	
	left = "LOOP"
	local arg={right,...}	
	local resp = right
	--print("temos x comandos: ", #arg)
	if(#arg >1) then
		atual = #arg -1
		resp = {"CSEQ",arg[atual], arg[atual+1]} 
		atual = atual -1
		while atual>0 do
			resp = {"CSEQ",arg[atual], resp} 
			atual = atual -1
		end
	else
		resp = arg[1]
	end
	return { left, op, resp}
end

function typeIf(left, op, right, ...)
	left="COND"
		local arg={right,...}	
		local seTrue 
		local seFalse
		local tamTrue = #arg

		--print("temos x comandos: ", #arg)
		if(#arg >1) then
			atual = #arg
			while atual>0 do
				if(arg[atual]=="else") then
					tamTrue = atual		
				end 
				atual = atual -1
			end
		
			atual = tamTrue-1
			if (atual >0) then
				seTrue = arg[atual]
				atual = atual -1

				while(atual>0) do
					seTrue = {"CSEQ",arg[atual], seTrue} 
					atual = atual -1
				end
			else
				seTrue = {}	
			end

			atual = #arg
			if (atual >tamTrue) then
				seFalse = arg[atual]
				atual = atual -1

				while(atual>tamTrue) do
					seFalse = {"CSEQ",arg[atual], seFalse} 
					atual = atual -1
				end
			else
				seFalse= {}	
			end

		else
			resp = arg[1]
		end
		return { left, op, seTrue,seFalse}
end

function typeNot(left, op, right, ...)
	return{"NOT",op, right}
end

function typeAnd(left, op, right,...)
	return{"AND",left, right}
end

function typeOr(left, op, right,...)
	if(left=="or")then
		left="OR"
	end
	return{"OR",left, right}
end
transformType =
    {
        ["+"]=typeSum,
      	["-"]=typeSub,
      	["*"]=typeMul,
      	["/"]=typeDiv,
      	[">"]=typeGT,
      	["<"]=typeLT,
      	[">="]=typeGE,
      	["<="]=typeLE,
      	["=="]=typeEQ,
      	[":="]=typeAssign,
      	["while"]=typeWhile,
      	["if"]=typeIf,
      	["Not"]=typeNot,
      	["and"]=typeAnd,
      	["or"] =typeOr
    }
	

local function node(p)

  return p  / function(left, op, right,...)
	--[[ inclusao do tipo de op --]]
	--print("NODE",left,op,right, um, dois)
	if(type(op)=="string") then	
		--print("ta aqui")
		if(op=="or" or op =="and") then
			return transformType[op](left, op, right)
		end
		op= transformType[op]()
	end	


	if(type(left) == "string") then
		
		if(left=="while" or left == "if" or left == "Not" and( left ~="or" and left~="and"))then
			--print("e ", left)			
			return transformType[left](left, op, right, ...)
		end
		if(left == "True" or left =="False") then
			
                	left = {"BOO",string.upper(left)}
        	end
		--left = transformType[left]
		if(left=="else") then
			return 	
		end

	end
	
	--[[ inclusao do tipo ID --]]
	if(type(left) == 'string')then
		--print("e string: ", left)
		left={"ID",left}
		 
	end        

	--[[ inclusao do tipo NUM --]]
	if(op==nil and right == nil) then
		if(type(left)=='number')then
			return{"NUM",left}
		else
			return left
		end
	end


    return {op, left, right }
  end
end


local function impFinal(p)
	return p / function(...)
		local arg={...}		
		local resp;
		--print("este e o  p",#arg)
		if(#arg >1) then
			atual = #arg -1
			resp = {"CSEQ",arg[atual], arg[atual+1]} 
			atual = atual -1
			while atual>0 do
				resp = {"CSEQ",arg[atual], resp} 
				atual = atual -1
			end
		else
			resp = arg[1]
		end
		return resp
	end 

end


local transformImp = lpeg.P({
	"s",
	s = impFinal(lpeg.V("cmd")^1),
	cmd = ((lpeg.V("assign") + lpeg.V("loop") +lpeg.V("cond")+ lpeg.V("exp") ) * (white + -1)),
	loop = node(loopValue * spc * lpeg.V("exp") * spc * "do" * spc * (lpeg.V("cmd")^1) ) * spc *";",
	assign = node(lpeg.V("id") * igual *lpeg.V("exp")),
	cond = node(condValue * spc * lpeg.V("exp") * spc * "then" * (spc * (lpeg.V("cmd")^1))^0 * spc * (elseValue * spc * (lpeg.V("cmd")^1))^0 * spc * ";"),
	exp = (lpeg.V("boolExp") + lpeg.V("aritExp")) ,
	boolExp = lpeg.V("negation") + lpeg.V("equality") + lpeg.V("conjunctionDis") + lpeg.V("compareEq") + lpeg.V("bool") +  lpeg.V("parentesisExp"),
	negation = node(notValue *spc * lpeg.V("boolExp")),
	equality = node(lpeg.V("aritExp") * compare * lpeg.V("exp")),
	conjunctionDis = node( (lpeg.V("parentesisExp") +lpeg.V("negation") + lpeg.V("equality") + lpeg.V("compareEq") + lpeg.V("aritExp") + lpeg.V("atom")) * andOr * (lpeg.V("boolExp") + lpeg.V("bool"))),
	compareEq = node(lpeg.V("aritExp") * compareEqual * lpeg.V("aritExp")),
	aritExp = lpeg.V("addSub")  + lpeg.V("multExp") + lpeg.V("multDiv"),
	addSub = node(lpeg.V("multExp") * addSubValue * lpeg.V("aritExp")),
	multExp = lpeg.V("multDiv") + lpeg.V("atom") + lpeg.V("parentesisExp"),
	multDiv = node(lpeg.V("atom") * multDivValue * lpeg.V("multExp")),
	parentesisExp = "(" * spc * lpeg.V("boolExp") * spc * ")",
	atom = node(integer + lpeg.V("bool") +  lpeg.V("id")),
	bool = node(boolValue),
	id = node(idValue - elseValue)

})

function parse.generator(s)
	return transformImp:match(s)
end

return parse

