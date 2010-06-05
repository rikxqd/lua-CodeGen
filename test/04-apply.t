#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(7)

tmpl = CodeGen{
    outer = [[
begin
${data:inner()}
end
]],
    inner = [[print("${name} = ${value}");]],
}
is( tmpl 'outer', [[
begin

end
]] , "empty" )

tmpl.data = {
    { name = 'key1', value = 1 },
    { name = 'key2', value = 2 },
    { name = 'key3', value = 3 },
}
is( tmpl 'outer', [[
begin
print("key1 = 1");print("key2 = 2");print("key3 = 3");
end
]] , "with array" )

tmpl.inner = 3.14
res, msg = tmpl 'outer'
is( res, [[
begin
${data:inner()}
end
]] , "not a template" )
is( msg, "outer:2: inner is not a template" )

tmpl.data = 3.14
res, msg = tmpl 'outer'
is( res, [[
begin
${data:inner()}
end
]] , "not a table" )
is( msg, "outer:2: data is not a table" )

tmpl = CodeGen{
    outer = [[
begin
${data:inner()}
end
]],
    inner = [[print(${it});]],
}
tmpl.data = { 1, 2, 3 }
is( tmpl 'outer', [[
begin
print(1);print(2);print(3);
end
]] , "it" )

