#!/usr/bin/lua
require("power")

a = array.new(1000)
    print(a)               --> userdata: 0x8064d48
    print(array.size(a))   --> 1000
    for i=1,1000 do
      array.set(a, i, 1/i)
    end
    print(array.get(a, 10))  --> 0.1


print(square(1.414213598))
print(cube(5))
