----------------------------
--版权:
--作者: liubo (564773807@qq.com)
--时间: 2016-04-24 17:29:43
--作用: 在lua基础上增加一些库函数
--备注:
----------------------------

--打印table
function table.print (luaTable, printFunction, indent)
    if not luaTable then
        Log.d("nil")
        return
    end

    local indent = indent or 0
    if printFunction == nil then printFunction = true end
    for k, v in pairs(luaTable) do
        if type(v) == "function" and not printFunction then
            --do nothing
        else
            if k == "__index" and v == luaTable then
                local str = "[" .. string.format("%q", k) .. "] = self"
                Log.d(str)
            else
                if type(k) == "string" then
                    k = string.format("%q", k)
                end
                local szSuffix = ""
                if type(v) == "table" then
                    szSuffix = "{"
                end
                local szPrefix = string.rep("    ", indent)
                local formatting = string.format("%s[%s] = %s", szPrefix, tostring(k), szSuffix)
                if type(v) == "table" then
                    Log.d(formatting)
                    table.print(v, printFunction, indent + 1)
                    Log.d(szPrefix.."},")
                else
                    local szValue = ""
                    if type(v) == "string" then
                        szValue = string.format("%q", v)
                    else
                        szValue = tostring(v)
                    end
                    Log.d(formatting..szValue..",")
                end
            end
        end
    end
end
