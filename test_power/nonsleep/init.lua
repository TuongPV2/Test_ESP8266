-- For non-sleep:
print(tmr.now())
print("Setting up WIFI...")
wifi.setmode(wifi.STATION)
wifi.sleeptype(wifi.MODEM_SLEEP)
--wifi.sta.config("TPLINK_TEST_ONLY","mqx54321")
wifi.sta.autoconnect(1)

function sendData()
    -- conection to thingspeak.com
    print("Sending data to thingspeak.com")
    conn=net.createConnection(net.TCP, 0) 
    conn:on("receive", function(conn, payload) print(payload) end)
    -- api.thingspeak.com 184.106.153.149
    conn:connect(80,'184.106.153.149') 
    
    conn:on("sent",function(conn)
                          print("OK. Closing connection")
                          conn:close()
                      end)
    conn:on("disconnection", function(conn)
                          print("Got disconnection...")
                        end)
    conn:on("connection", function(sck,c)
        print("Connected!")
        conn:send("GET /update?key=ATW2Q8TJ54R92PMQ&field1=55&field2=66 HTTP/1.1\r\nUser-Agent: curl/7.41.0\r\nHost: 184.106.153.149\r\nAccept: */*\r\n\r\n") 
                        end)
end

function startTest()
    print(tmr.now())
    print("STATION_GOT_IP")
    print(wifi.sta.getip())
    -- Setup timer for sending data every 6s
    tmr.alarm(1, 20000, tmr.ALARM_AUTO, sendData)
end

wifi.sta.eventMonReg(wifi.STA_GOTIP, startTest)
wifi.sta.eventMonStart()
