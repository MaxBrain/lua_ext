message("test message")
message("test message", 1)
message("test\nmessage", 2)
message("connection state is " .. tostring(isConnected()), 3)

function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*[/\\])")
end

libinit = package.loadlib(script_path() .. "QuikExt\\x64\\Debug\\QuikExt.dll", "libinit")
libinit()
msgbox("Hey, it worked!", "Lua Message Box")

ds = nil

f = io.open( script_path() ..  "log.txt", 'w' )

function write_data(c, index)
    local t = c:T(index)
    local _str = string.format("#%d of %d\t%.4f\t%.4f\t%.4f\t%.4f\t%.0f\t%02d.%02d.%04d %02d:%02d:%02d.%04d\n",
        index, c:Size(),c:O(index), c:H(index), c:L(index), 
        c:C(index), c:V(index),
        t.day, t.month, t.year, t.hour, t.min, t.sec, t.ms
    )
    f:write(_str)
    f:flush()
end

function cb( index )
    write_data(ds, index)
end

function main()
    message("Create data source: GAZP")
    ds = CreateDataSource("TQBR", "GAZP", INTERVAL_M1)
    if error_desc then
        message("Error: " .. error_desc, 3)
        return
    end
    for index = 1, ds:Size() do
        write_data(ds, index)
    end
    ds: SetUpdateCallback (cb)
    while true do
        for i = 1, 10 do
            sleep(100)
        end
    end
end

function OnStop(flag)
    f:close()
    return 0 -- задается таймаут в 0 секунд
end
