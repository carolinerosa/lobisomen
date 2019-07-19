lpeg=require "lpeg"


parse = {}

local white = lpeg.S(" \t\r\n") ^ 0


--[[ regras basicas gramatica --]]
local integer = white * lpeg.R("09") ^ 1 / tonumber
local multDivValue = white * lpeg.C(lpeg.S("/*"))
local addSubValue = white * lpeg.C(lpeg.S("+-"))
local notValue = white * lpeg.C("not")
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

--[[regras de let delref valref--]]
local letValue = white * lpeg.C("let")
local varValue = white * lpeg.C("var")

local constValue = white * lpeg.C("const")
local deRefValue = white * lpeg.C("*")
local valRefValue = white * lpeg.C("&")

--[[regras de fn]]
local fnValue = white * lpeg.C("fn")
local fnRecValue = white * lpeg.C("rec")


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

function typeVar(left, op, right,...)
	
	right = {"REF",right}
	return{"BIND",op,  right}
end

function typeConst(left, op, right,...)
	
	-- right = {"const",right}
	return{"BIND",op,  right}
end


function typeLet(left, op, right, ...)



	left = "BLK"

	local arg={op,right,...}

	local atual=2
	local resp = right
		
	--print("temos x comandos: ", #arg)
	
	
	if(atual <=#arg and (arg[atual][1]=="BIND" or  arg[atual][1]=="RBND")) then
		--print("e bind", arg[(atual)][1])
		resp = {"DSEQ",arg[atual-1], arg[atual]} 
		atual = atual +1
		while atual<=#arg and (arg[atual][1]=="BIND" or  arg[atual][1]=="RBND") do
		
			--print("e bind", arg[(atual)][1], " atual" , atual)
			resp = {"DSEQ",arg[atual], resp} 
			atual = atual -1
		end
			
	
		if((atual) <#arg ) then

			--print("não e bind", arg[(atual)][1])
			respCSeq = {"CSEQ",arg[atual], arg[atual+1]} 
			atual = atual +2
			while atual<=#arg  do
				respCSeq = {"CSEQ",arg[atual], respCSeq} 
				atual = atual -1
			end
			resp= {resp,respCSeq}
		else
			resp = {resp,arg[#arg]}
		end
		
		return { left, resp[1],resp[2]}
	
	end
	if((atual) <#arg and (arg[atual][1]~="BIND" or  arg[atual][1]~="RBND")) then

		--print("não e bind", arg[(atual-1)][1])
		resp = {"CSEQ",arg[atual-1], arg[atual]} 
		atual = atual +1
		while atual<=#arg  do
			resp = {"CSEQ",arg[atual], resp} 
			atual = atual -1
		end
	
	end
	
	
	return { left,op, resp}
end

function typeDeRef(id)

	return {"DEREF", id}
end

function typeValRef(id)

	return {"VALREF", id}
end
function typeFn(left, op, right,...)
	id= op
    --[[verificar onde termina o abs]]
    local abs={right,...}
    local len = #abs
    local absTwo = abs[len]
    
     table.remove(abs,len)
	
    abs = {"ABS",abs,absTwo}
    return{"BIND",id,  abs}   
end


function typeFnRec(left, op, right,...)
	print("e recursivo")
	id= right
    --[[verificar onde termina o abs]]
    local abs={...}	
    --print("temos x comandos: ", #arg)
    
    local len = #abs
    local absTwo = abs[len]
    
     table.remove(abs,len)
	
    abs = {"ABS",abs,absTwo}
    
    return{"RBND",id,  abs}   
end

function typeCall(id,...)
    local actuals = {...}
    return{"CALL",id,  actuals}   
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
      	["not"]=typeNot,
      	["and"]=typeAnd,
      	["or"] =typeOr,
	["let"] = typeLet,
	["var"]=typeVar,
	["const"]=typeConst,
	["*Pont"]=typeDeRef,
	["&Pont"]=typeValRef,
	["fn"]=typeFn,
	["rec"]=typeFnRec,
	["call"]=typeCall
    }
	

local function node(p)

	return p  / function(term1, term2, term3,...)
	--[[ inclusao do tipo de term2 --]]
	--print("NODE")
	if(type(term2)=="string") then	
		--print("ta aqui")
		if(term2=="or" or term2 =="and") then
			return transformType[term2](term1, term2, term3)
		end
		term2= transformType[term2]()
	end	
	

	if(type(term1) == "string") then
		
		if(term1=="while" or term1 == "if" or term1 == "not" or term1=="var" or term1=="let" or term1=="fn"  or term1=="rec" or term1=="const" and( term1 ~="or" and term1~="and"))then
			--print("e ", term1)			
			return transformType[term1](term1, term2, term3, ...)
		end
		if(term1 == "True" or term1 =="False") then
			
                	term1 = {"BOO",string.upper(term1)}
        	end
		--term1 = transformType[term1]
		if(term1=="else") then
			return 	
		end

	end
	
	--[[ inclusao do Deref e ValRef --]]
	if(term1 == "*" or term1 == "&") then
		return transformType[term1 .. "Pont"](term2)
	end

	--[[ inclusao do tipo ID --]]
	if(type(term1) == 'string')then
		--print("e string: ", term1)
		term1={"ID",term1}
		 
	end        

	--[[ inclusao do tipo NUM --]]
	if(term2==nil and term3 == nil) then
		if(type(term1)=='number')then
			return{"NUM",term1}
		else
			return term1
		end
	end


    return {term2, term1, term3 }
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

local function nodeCall(p)
	return p / function(id, ...)
		return transformType["call"](id, ...)
	end 

end

local transformImp = lpeg.P({
	"s",
	s = impFinal(lpeg.V("cmd")^1),
	cmd = (lpeg.V("let")+ (lpeg.V("call")+lpeg.V("assign") + lpeg.V("loop") +lpeg.V("cond") ) * (white + -1)),
	let = node(  (letValue * spc * lpeg.V("fn") *  spc * "in" * spc * lpeg.V("cmd")^1 *spc* "end" ) + (letValue * spc *  ((lpeg.V("typeLet") * ("," * lpeg.V("typeLet") * spc)^0 * spc *"in" * spc * lpeg.V("cmd")^1 *spc* "end")))),
	typeLet = node(((varValue + constValue) * spc * lpeg.V("id") *spc* "=" * spc* lpeg.V("exp") )  ),
	call = nodeCall(lpeg.V("id") * "(" * lpeg.V("exp") *( ("," *spc *  lpeg.V("exp") * spc)^0+spc) *")"),
	fn = node( ( (fnRecValue * spc) + spc) * fnValue * spc * lpeg.V("id") * spc * "(" * spc * ((lpeg.V("id")*spc * ("," *spc* lpeg.V("id"))^0) +(spc) ) * spc * ")"* spc * "=" * spc * lpeg.V("cmd") *spc ),
	loop = node(loopValue * spc * lpeg.V("exp") * spc * "do" * spc * (lpeg.V("cmd")^1) ) * spc *"end",
	assign = node(lpeg.V("id") * igual *lpeg.V("exp")),
	cond = node(condValue * spc * lpeg.V("exp") * spc * "then" * (spc * (lpeg.V("cmd")^1))^0 * spc * (elseValue * spc * (lpeg.V("cmd")^1))^0 * spc * "end"),
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
	atom = node(integer + lpeg.V("bool") + ((deRefValue + valRefValue) * lpeg.V("id") ) + lpeg.V("id")),
	bool = node(boolValue),
	id = node(idValue - elseValue)

})

function parse.generator(s)
	return transformImp:match(s)
end

return parse

