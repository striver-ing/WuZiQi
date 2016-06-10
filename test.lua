function test1(n)
    n = n + 1
    print ("n = " .. n)
end

function testTb(tb)
    tb.a = 3
    print ("tb.a = " .. tb.a)
end

function testTb()
    print("无参数的testTb")
end

local n = 0
test1(n)
print ("out n = ".. n)

local tb = {a = 2}
testTb(tb)
testTb()
print ("out tb.a = " .. tb.a)
