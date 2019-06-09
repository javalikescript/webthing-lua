--- The Property class module.
-- @module webthing.Property
-- @pragma nostrip

local tables = require('jls.util.tables')
--local logger = require('jls.lang.logger')

--- The Property class represents a thing property.
-- @type Property
return require('jls.lang.class').create(function(property)

    --- Creates a new Property.
    -- @function Property:new
    -- @param metadata the property metadata, i.e. type, description, unit, etc., as a table
    -- @param[opt] initialValue the property value
    -- @return a new Property
    -- @usage
    --local property = Property:new()
    function property:initialize(metadata, initialValue)
        self.value = initialValue;
        self.metadata = metadata or {};
    end

    function property:getValue()
        return self.value
    end

    function property:setValue(value)
        -- TODO validate and notify
        self.value = value
        return self
    end

    --- Returns the metadata of this property.
    -- @return the metadata of this property.
    function property:getMetadata()
        return self.metadata
    end

    --- Returns this property description.
    -- @return this property description.
    function property:asPropertyDescription()
        --return tables.deepCopy(self.metadata)
        return tables.shallowCopy(self.metadata)
    end

end)