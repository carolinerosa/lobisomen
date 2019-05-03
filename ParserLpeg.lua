
lpeg=require "lpeg"

local white = lpeg.S(" \t\r\n") ^ 0

local integer = white * lpeg.R("09") ^ 1 / tonumber
local muldiv = white * lpeg.C(lpeg.S("/*"))
local addsub = white * lpeg.C(lpeg.S("+-"))
local spc = lpeg.S(" \t\n")^0

local function node(p)

  return p  / function(left, op, right)
    return {op, left, right }
  end
end

local calculator = lpeg.P({
  "input",
  input =lpeg.V("exp") * -1,
  exp =  lpeg.V("term") + ( lpeg.V("factor") )  + integer,
  term = node((spc * "(" * (lpeg.V("factor") + integer) * addsub * lpeg.V("exp") * ")" * spc) + (lpeg.V("factor") + integer) * addsub * lpeg.V("exp"))
  factor = node(( spc * "(" * integer * muldiv * lpeg.V("exp")* ")" * spc) +( integer * muldiv * lpeg.V("exp") ) )
})

function generator(s)
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
