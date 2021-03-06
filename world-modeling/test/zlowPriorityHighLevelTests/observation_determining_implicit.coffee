assert = require 'assert'
intention = require '../../model/intention'
environment = require '../../model/entities/environment'

describe('Observing an implicit entity after moving to it',->
    beforeEach(->
        environment.reset()
    )
    
    it('should replace the implicit entity with the correct one' , (done)->
        intention.interpretAsync("walk to body")
        .then((intent)->
            environment.reactAsync(intent)            
        )
        .then((results)->
            result = results.shift()
            assert.strictEqual("movement",result.type)
            
            intention.interpretAsync("look at it")
        )
        .then((intent)->
            intent = intent.shift()
            assert.strictEqual("observation",intent.type)
            assert.strictEqual("implicit",intent.entity)
            
            environment.reactAsync(intent)
        )
        .then((results)->
            result = results.shift()
            intention = result.intention
            
            assert.strictEqual("body",intention.entity, "intention should be implicitly set to body")
        )
        .done((result,error)->
            done(error)
            
        )
    )
)