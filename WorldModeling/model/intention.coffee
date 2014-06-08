q = require 'Q'
entities = require('./entities/environment').getAllEntityNames()
characters = require('./entities/environment').getAllCharacterNames()
knowledgeKeys = require('./entities/environment').getAllCharacterKnowledge()

isQuestion = /\?|what |where |why |how |ask |can you |tell /
isExclamation = /(hi|hello|howdy|greetings|!)( .*|$)/

entitiesRegexString = "(#{entities.join('|')})".toLowerCase()
containsEntity = new RegExp(entitiesRegexString)

knowledgeRegexString = "(#{knowledgeKeys.join('|')})".toLowerCase()
knowledgeItem = new RegExp(knowledgeRegexString)

charactersRegexString = "(#{characters.join('|')})".toLowerCase()
containsCharacter = new RegExp(charactersRegexString)

isDirection = /(north|south|east|west|left|right|up|down|around)/
isMovementVerb = /^(go|walk|move|jump|sprint|step|run)/
distnaceAndMetric = /(\d+ ?[a-zA-Z]*|\d+ ?[a-zA-Z]*)( |$)/

isObservationVerb = /^(inspect|examine|check|analyse|observe|look)/


module.exports.interpretAsync = (input)->
    deferred = q.defer()
    input = input.toLowerCase()

    setImmediate(->
        direction = undefined 
        object = undefined
        distance = undefined
        subject = undefined 
        unit = undefined
        verb = undefined
        type = 'action'

        if isMovementVerb.test(input) && ( isDirection.test(input) || containsEntity.test(input) )
            type = 'movement'
            distance = 'implicit'
            if containsEntity.test(input)
                objectMatch = containsEntity.exec(input)
                object = objectMatch[0]
            
            if distnaceAndMetric.test(input)
                distanceString = distnaceAndMetric.exec(input)[0].trim()
                unit = /[a-zA-Z]+/.exec(distanceString)[0]
                distance = parseInt(/\d+/.exec(distanceString)[0])
            

        if isObservationVerb.test(input) && ( containsEntity.test(input) || isDirection.test(input) )
            type = 'observation'
            directionMatch = isDirection.exec(input)
            objectMatch = containsEntity.exec(input)
            if objectMatch then object = objectMatch[0]
            if directionMatch then direction = directionMatch[0]

        if isQuestion.test(input) || isExclamation.test(input)
            type = 'dialog'
            object = 'implicit'
            match = containsCharacter.exec(input)
            if match then object = match[0]
            match = knowledgeItem.exec(input)
            if match then subject = match[0]
            
        if type == 'action' 
            verb = input.substr(0,input.lastIndexOf(' ')).trim()
            object = input.substr(input.lastIndexOf(' ')).trim()
            

        deferred.resolve({
            input: input
            type: type
            isQuestion : isQuestion.test(input)
            isExclamation : isExclamation.test(input)
            subject : subject
            direction : direction
            distance : distance
            unit : unit
            object : object
            verb : verb
        });
    )
    return deferred.promise;
    
   