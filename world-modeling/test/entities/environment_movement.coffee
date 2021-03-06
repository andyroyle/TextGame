assert = require 'assert'
intention = require '../../model/intention'
environment = require '../../model/entities/environment'

describe('Interpreting movement in environment',->
    beforeEach(->
        environment.reset()
    )
    
    it('moving to the body',(done)->
        intention.interpretAsync('go to body')
        .then((interpretation)->
            environment.reactAsync(interpretation))
        .done((results)->
            result = results.shift()
            assert.strictEqual("Wildcard walks to the body.",result.text)
            assert.strictEqual("The officers follow him.",result.chain[0].text)
            done())
    ) 
    
    it('moving to an nonexistent object',(done)->
        input = 'go to the balloon'
        intention.interpretAsync(input)
        .then((interpretation)->
            environment.reactAsync(interpretation))
        .done((results)->
            result = results.shift()
            assert.strictEqual("There is no balloon around to walk to.",result.text)
            done())
    )
    
    it('moving to cardinal location', (done)->
        input = 'walk north'
        intention.interpretAsync(input)
        .then((interpretation)->
            environment.reactAsync(interpretation))
        .then((results)->
            result = results.shift()
            assert.strictEqual("Wildcard walks north 10 meters.",result.text)
            assert.strictEqual("The officers follow him.",result.chain[0].text)
        )
        .done((res,error)->
            done(error);
        )
    )
)