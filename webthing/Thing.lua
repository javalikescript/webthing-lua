--- The Thing class module.
-- @module webthing.Thing
-- @pragma nostrip

--local logger = require("jls.lang.logger")

--- The Thing class represents a device.
-- @type Thing
return require('jls.lang.class').create(function(thing)

    --- Creates a new Thing.
    -- @function Thing:new
    -- @param name The thing's name
    -- @param[opt] tType The thing's type(s)
    -- @param[opt] description Description of the thing
    -- @return a new Thing
    -- @usage
    --local thing = Thing:new()
    function thing:initialize(name, tType, description)
        if type(tType) == 'string' then
            tType = {tType}
        end
        self.name = name;
        self.tType = tType or {};
        self.description = description or '';
        self.properties = {}
    end

    --- Returns the name of this thing.
    -- @return the name of this thing.
    function thing:getName()
        return self.name
    end

    --- Adds a property to this thing.
    -- @param name The property's name
    -- @param property The property to add
    -- @return this thing
    function thing:addProperty(name, property)
        self.properties[name] = property
        return self
    end

    function thing:findProperty(name)
        return self.properties[name]
    end

    function thing:getProperty(name)
        local property = self:findProperty(name)
        if property then
            return property:getValue()
        end
    end

    function thing:getPropertyDescriptions()
        local descriptions = {}
        for name, property in pairs(self.properties) do
            descriptions[name] = property:asPropertyDescription()
        end
        return descriptions
    end

    function thing:getProperties()
        local props = {}
        for name, property in pairs(self.properties) do
            props[name] = property:getValue()
        end
        return props
    end

    --- Returns this thing description.
    -- @return this thing description.
    function thing:asThingDescription()
        return {
            name = self.name,
            ['@context'] = 'https://iot.mozilla.org/schemas',
            ['@type'] = self.tType,
            properties = self:getPropertyDescriptions(),
            actions = {},
            events = {},
            links = {}
        }
    end

end)