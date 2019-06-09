local class = require('jls.lang.class')
--local logger = require('jls.lang.logger')
local http = require('jls.net.http')
local httpHandler = require('jls.net.http.handler')
local json = require('jls.util.json')

 
local REST_THING = {
    [''] = function(exchange)
        return exchange.attributes.thing:asThingDescription()
    end,
    properties = {
        [''] = function(exchange)
            return exchange.attributes.thing:getProperties()
        end,
        ['/any'] = function(exchange)
            local request = exchange:getRequest()
            local method = string.upper(request:getMethod())
            local propertyName = exchange.attributes.propertyName
            local property = exchange.attributes.thing:findProperty(propertyName)
            if property then
                if method == http.CONST.METHOD_GET then
                    return {[propertyName] = property:getValue()}
                elseif method == http.CONST.METHOD_PUT then
                    local rt = json.decode(request:getBody())
                    local value = rt[propertyName]
                    if value then
                        property:setValue(value)
                    end
                else
                    httpHandler.methodNotAllowed(exchange)
                    return false
                end
            else
                httpHandler.notFound(exchange)
                return false
            end
        end,
        name = 'propertyName'
    }
}

local REST_THINGS = {
    [''] = function(exchange)
        local descriptions = {}
        for name, thing in pairs(exchange.attributes.things) do
            local description = thing:asThingDescription()
            description.href = '/things/'..name
            table.insert(descriptions, description)
        end
        return descriptions;
    end,
    ['/any'] = REST_THING,
    name = 'thing',
    value = function(exchange, name)
        return exchange.attributes.things[name]
    end
}

local SingleThing = class.create(function(singleThing)
    function singleThing:initialize(thing)
        self.thing = thing
    end
end)

local MultipleThings = class.create(function(multipleThings)
    function multipleThings:initialize(things)
        self.things = things or {}
    end
    function multipleThings:addThing(name, thing)
        self.things[name] = thing
        return self
    end
end)

local Server = class.create(function(server)

    function server:initialize(thingHandler, httpServer)
        self.httpServer = httpServer or http.Server:new()
        self.thingHandler = thingHandler
        if SingleThing:isInstance(self.thingHandler) then
            self.httpServer:createContext('/(.*)', httpHandler.rest, {
                attributes = {
                    thing = self.thingHandler.thing
                },
                handlers = REST_THING
            })
        elseif MultipleThings:isInstance(self.thingHandler) then
            self.httpServer:createContext('/(.*)', httpHandler.rest, {
                attributes = {
                    things = self.thingHandler.things
                },
                handlers = {
                    things = REST_THINGS
                }
            })
        end
    end

    function server:getHTTPServer()
        return self.httpServer
    end

    function server:getThingHandler()
        return self.thingHandler
    end

end)


return {
    SingleThing = SingleThing,
    MultipleThings = MultipleThings,
    Server = Server
}