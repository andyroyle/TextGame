q = require 'Q'
_ = require 'lodash'

composingEntities = [
    wildcard = require('./wildcard').new()
    body = require('./body').new()
    mark = require('./mark').new()
    tractor = require('./tractor').new()
    paramedics = require('./paramedics').new()
    Policemen = require('./policemen').new()
]

extractAllNamesAndAliases = (entities, filter = -> true) ->
    result = []
    if(entities.length > 0)
        for entity in entities
            sub_names = extractAllNamesAndAliases(entity.composing)
            result = [].concat.apply(result, sub_names)
            if not filter(entity)
                continue
            result = [].concat.apply(result, entity.aliases)
            result.push(entity.name)
    result

getCharacterKnowledge = (entities)->
    result = []
    if(entities.length > 0)
        for entity in entities
            if entity.isCharacter
                result = [].concat.apply(result , entity.getKnowledgeKeys())
                result = [].concat.apply(result , getCharacterKnowledge(entity.composing))
    result
    
getChain = (stimuli) ->
    chain_reactions = []
    for entity in composingEntities
        if stimuli.subject != entity.name
            entity_reactions = entity.react(stimuli)
            if(!Array.isArray(entity_reactions))
                entity_reactions = [entity_reactions]
            chain_reactions = [].concat.apply(chain_reactions, entity_reactions)
    chain_reactions
    
retrieveEntityByName = (name, entityTree = composingEntities)->
    for entity in entityTree
        if entity.name == name then return entity
        result = retrieveEntityByName(name, entity.composing)
        if result then return result

module.exports.getAllEntityNames = ->
    extractAllNamesAndAliases(composingEntities).concat('environment')
        
module.exports.getAllNonCharacterNames = ->
    extractAllNamesAndAliases(composingEntities, (entity)-> not entity.isCharacter)
    
module.exports.getAllCharacterNames = ->
    extractAllNamesAndAliases(composingEntities, (entity)-> entity.isCharacter)

module.exports.getAllCharacterKnowledge = ->
    _.uniq(getCharacterKnowledge(composingEntities))
    
module.exports.getObjectByName = retrieveEntityByName
module.exports.composing = composingEntities

module.exports.reactAsync = (intention)->
    deferred = q.defer()

    reaction = wildcard.execute(intention)
    reaction.chain = getChain(reaction)

    deferred.resolve(reaction)

    deferred.promise;