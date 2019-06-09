local event = require('jls.lang.event')
local server = require('webthing.server')
local sampleThings = require('basics.sampleThings')


local hostname, port = '::', 3001

local svr = server.Server:new(server.SingleThing:new(sampleThings.myLamp))
local httpServer = svr:getHTTPServer()
httpServer:bind(hostname, port):next(function()
  print('Server bound to "'..hostname..'" on port '..tostring(port))
end, function(err) -- could failed if address is in use or hostname cannot be resolved
  print('Cannot bind HTTP server, '..tostring(err))
end)

event:loop()
event:close()

print('Server stopped')



