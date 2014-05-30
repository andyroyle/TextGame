characters = require('./story/characters').characters

module.exports.toDecorator = (argument)->
    switch typeof argument
        when 'function'
            wrapper = ->
                argument(@)
                wrapper.wasUsed = true
            return wrapper

        when 'string'
            stringDecorator = ->
                @text argument
                stringDecorator.wasUsed = true
            return stringDecorator

        when 'object'
            if Array.isArray(argument)
                count = 0;
                arrayDecorator = ->
                    @text argument[count];
                    if argument.length > count
                        count++
                    else
                        arrayDecorator.wasUsed = true
                return arrayDecorator

    return undefined;
    
nameMatchRegex = /^(.*):/
module.exports.extractRespondingCharacter = (text) ->
    for line in text.split('\n')
        match = nameMatchRegex.exec(line)
        if match != null && match[0].match(/Willy|Wildcard|Detecive/) == null
            name = match[1]
            return name.trim().toLowerCase()