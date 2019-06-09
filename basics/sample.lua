local json = require('jls.util.json')
local sampleThings = require('basics.sampleThings')

print(json.encode(sampleThings.myLamp:asThingDescription()))
print(json.encode(sampleThings.myHumiditySensor:asThingDescription()))
