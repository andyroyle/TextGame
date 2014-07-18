q = require 'Q'
environment = require './environment'
Character = require '../character'

class Wildcard extends Character
    constructor: ->
        super
            name: "wildcard"
            location: { x: 20, y: 10 }

    dialogue: (entity, intention)->
        switch(intention.subtype)
            when 'exclamation'
                return @greet(entity)
            when 'question'
                return  @askAbout(entity, intention.subject, intention.attribute , intention)
            else
                return {
                input: intention.input
                type: intention.type
                text: "Wildcard : #{intention.input}"
                }
            
    execute: (intention)->
        entity = environment.getObjectByName(intention.entity)

        if intention.type != 'movement' && entity && not @isNear(entity)
            return requires: {
                input : "go to #{intention.entity}"
                entity: intention.entity
                type: 'movement'
            }
        
        switch  intention.type
            when 'movement'
                return @move(entity)
            when 'dialogue'
                return @dialogue(entity,intention)
            when 'silence'
                return {
                    input : ""
                    type : intention.type 
                    text : "Wildcard does nothing."
                }
            when 'action'
                return {
                    input : intention.input
                    type : intention.type 
                    text : "Wildcard feels like #{intention.verb}ing something. But he can't right now."
                }
            when 'observation'
                console.log entity
                if not entity
                    text = "Wildcard looks at the #{intention.entity}. There is nothing special."
                else 
                    text = "Wildcard looks at #{intention.entity}. There is nothing special."
                
                return {
                    input : intention.input
                    type : intention.type 
                    text : text
                }

module.exports.new = ->
    new Wildcard()