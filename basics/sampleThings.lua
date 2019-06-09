local Property = require('webthing.Property')
local Thing = require('webthing.Thing')

local myLamp = Thing:new('My Lamp', {'OnOffSwitch', 'Light'}, 'A web connected lamp')
myLamp:addProperty('on', Property:new({
    ['@type'] = 'OnOffProperty',
    title = 'On/Off',
    type = 'boolean',
    description = 'Whether the lamp is turned on'
}, true));
myLamp:addProperty('brightness', Property:new({
    ['@type'] = 'BrightnessProperty',
    title = 'Brightness',
    type = 'integer',
    description = 'The level of light from 0-100',
    minimum = 0,
    maximum = 100,
    unit = 'percent'
}, 50));

local myHumiditySensor = Thing:new('My Humidity Sensor', 'MultiLevelSensor', 'A web connected humidity sensor')
myHumiditySensor:addProperty('level', Property:new({
    ['@type'] = 'LevelProperty',
    title = 'Humidity',
    type = 'number',
    description = 'The current humidity in %',
    minimum = 0,
    maximum = 100,
    unit = 'percent',
    readOnly = true
}, 0));

return {
    myLamp = myLamp,
    myHumiditySensor = myHumiditySensor
}