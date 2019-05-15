lpeg=require "lpeg"

require "power"

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
--local cseqValue = white * lpeg.C("CSEQ")
--local condValue = white * lpeg.C("COND")
local spc = lpeg.S(" \t\n")^0

a = array.new(1000)
    print(a)               --> userdata: 0x8064d48
    print(array.size(a))   --> 1000
    for i=1,1000 do
      array.set(a, i, 1/i)
    end
    print(array.get(a, 10))  --> 0.1


function each(o)
   local e = o:GetEnumerator()
   return function()
      if e:MoveNext() then
        return e.Current
     end
   end
end


local function node(p)

  return p  / function(left, op, right)
	--[[ inclusao do tipo de op --]]
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
		return { left, op, right}
	end

        
	--[[ inclusao do tipo BOO --]]
	if(left == "True" or left =="False") then
                left = {"BOO",left}
        end

	if(left == "Not") then
                return{left,op, right}
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

local function nodeCmd(p)
	return p / function(op,id,atrib, value)

		if(id =='=') then
			value ="ASSIGN"
			return{value,op, atrib }
		end

		return{op,id, atrib, value}
		
	end
end
local function teste(p)
	return p / function(op, um, doi, tres)
		
		print("estamos no teste",op, um, doi, tres)
		for u,v in ipairs(op) do
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
              			print(u,v)
			end
	         end

		return {op}
	end
end

local function testeUp(p)
	return p / function(op, um, doi, tres)
		print("estamos no teste2: ",op, um, doi, tres)
		print("este e o  p",p, array.size(p))
		luaL_openlib(L, "array", arraylib, 0);
		print(inspect(getmetatable(p)))
		for x in each (p) do
		print("tentandooo", x)
		print(inspect(getmetatable(p)))
		end
			

		for u,v in ipairs(op) do
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
              			print(u,v)
			end
	         end
		saida = {op,um, doi, tres}
		return saida
	end
end


local transformImp = lpeg.P({
	"s",
	s = testeUp(lpeg.V("cmd")^1),
	cmd = ((lpeg.V("assign") + lpeg.V("loop") + lpeg.V("exp")) * (white + -1)),
	loop = node(loopValue * spc * lpeg.V("exp") * spc * "do" * spc * lpeg.V("cmd")),
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
	print("Entrou aqui", s)
--	return transformImp:match(s)
  print((transformImp:match("3 + 2\n4 + 7")))
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

