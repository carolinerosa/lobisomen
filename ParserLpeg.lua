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
local loopValue = white * lpeg.C("While")
local spc = lpeg.S(" \t\n")^0


local function node(p)

  return p  / function(left, op, right,...)
	--[[ inclusao do tipo de op --]]
--	print("NODE",left,op,right, um, dois)
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

	if(op == "==") then
                op = "EQ"
        end

	if(op == "==") then
                op = "EQ"
        end

	if(op == ":=") then
                op = "ASSIGN"
        end

	if(left =="While") then
		left = "LOOP"
		return { left, op, {right ,...}}
	end

        
	--[[ inclusao do tipo BOO --]]
	if(left == "True" or left =="False") then
                left = {"BOO",left}
        end

	if(left == "Not") then
                return{"NOT",op, right}
        end

	if(op == "and") then
                return{"AND",left, right}
        end

	if(op == "or") then
                return{"OR",left, right}
        end




	
	--[[ inclusao do tipo ID --]]
	if(type(left) == 'string')then
		print("e string: ", left)
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
		for h,v in ipairs(arg) do
			if (type(v) == 'table') then 
				for t,u in ipairs(v) do
			  		if(type(u) == 'table')then
  						for y,z in ipairs(u) do
			  				--print("filho1",t,y, z)
							if(type(z) == 'table')then
								for k,l in ipairs(z) do
  									--print("filho2",y,k,l)
									if(type(l) == 'table')then
										for q,w in ipairs(l) do
		  									--print("filho3",k,q,w)
										end
									end
								end
							end
			  			end
				  	else		
				  		--print(t,u) 
  	
  					end
             		 	end
          		else
              			--print(h,v)
			end
	         end
		return resp
	end 

end


local transformImp = lpeg.P({
	"s",
	s = impFinal(lpeg.V("cmd")^1),
	cmd = ((lpeg.V("assign") + lpeg.V("loop") + lpeg.V("exp")) * (white + -1)),
	loop = node(loopValue * spc * lpeg.V("exp") * spc * "do" * spc * (lpeg.V("cmd")^1) ),
	assign = node(lpeg.V("id") * igual *lpeg.V("exp")),
	exp = lpeg.V("boolExp") + lpeg.V("aritExp"),
	boolExp = lpeg.V("negation") + lpeg.V("equality") +  lpeg.V("parentesisExp") + lpeg.V("conjunctionDis") + lpeg.V("compareEq") + lpeg.V("bool"),
	negation = node(notValue *spc * lpeg.V("boolExp")),
	equality = node(lpeg.V("aritExp") * compare * lpeg.V("exp")),
	conjunctionDis = node( (lpeg.V("negation") + lpeg.V("equality") + lpeg.V("compareEq") + lpeg.V("aritExp")) * andOr * (lpeg.V("boolExp") + lpeg.V("bool"))),
	compareEq = node(lpeg.V("aritExp") * compareEqual * lpeg.V("aritExp")),
	aritExp = lpeg.V("addSub")  + lpeg.V("multExp") + lpeg.V("multDiv"),
	addSub = node(lpeg.V("multExp") * addSubValue * lpeg.V("aritExp")),
	multExp = lpeg.V("multDiv") + lpeg.V("atom") + lpeg.V("parentesisExp"),
	multDiv = node(lpeg.V("atom") * multDivValue * lpeg.V("multExp")),
	parentesisExp = "(" * spc * lpeg.V("boolExp") * spc * ")",
	atom = node(integer + lpeg.V("bool") +  lpeg.V("id")),
	bool = node(boolValue),
	id = node(idValue)

})

function parse.generator(s)
	--print("Entrou aqui", s)
--	return transformImp:match(s)
  --print((transformImp:match("3 + 2\n4 + 7")))
--[[      for i,v in ipairs(transformImp:match("3 + 2\n4 + 7")) do 
          if (type(v) == 'table') then 
              for t,u in ipairs(v) do
  		if(type(u) == 'table')then
  			for y,z in ipairs(u) do
  				print(y, z)
if(type(z) == 'table')then
				for k,l in ipairs(z) do
  					print(k,l)
end
				end
  			end
  		else		
  		print(t,u) 
  	
  		end
              end
          else
              print(i,v)
          end
      end--]]

return transformImp:match(s)
end

--[[
expressao = io.stdin:read'*l'
while (expressao~='exit') do
    print("Expressão: ",expressao)
    generator(expressao)
    expressao = io.stdin:read'*l'
end
--]]
--Olhar COND & LOOP podendo receber expressoes boleanasem vez de bools
--Tudo que recebe uma bool pode receber uma expressao boleana

return parse

