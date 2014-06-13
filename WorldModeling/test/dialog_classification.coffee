assert = require 'assert'
intention = require '../model/intention'

describe('Classifying dialog intentions correctly', ->
    describe('by input structure that is a question', ->
        questions = [
            {input:"what is your name",subject:"you" , attribute : "name"}
            {input:"are you ok ?", subject:"you"  }
            {input:"how are you?", subject:"you" }
            {input:"how do you do", subject: "you" }
            {input:"what is the case",subject:"case"}
            {input:"how come ?"}
            {input:"where is the body?",subject:"body"}
            {input:"ask about the body",subject:"body"}
            {input:"did you kill him",subject:"you",attribute:"kill"}
            {input:"tell me what you saw",subject:"you",attribute:"saw"}
            {input:"can you help", subject:"you", attribute: "help"}
            {input:"body ?", subject : "body"}
            {input:"huh ?"}
        ]

        questions.forEach((question)->
            it(question.input, (done)->
                intention.interpretAsync(question.input).done((res, err)->
                    if (err) then throw err
                    assert.strictEqual(res.type, 'dialog', "For input #{res.input}")
                 
                    assert.strictEqual(res.isQuestion, true , "Not classified as question #{res.input}")
                    assert.strictEqual(res.isExclamation, false )

                    if question.subject
                        assert.strictEqual(res.subject, question.subject, "For input #{res.input}")
                    if question.attribute
                        assert.strictEqual(res.attribute, question.attribute, "For input #{res.input}")
                        
                    done()
                )
            ))
    )

    describe('by exclamations', ->
        exclamation = [
            "hi"
            "hello"
            'howdy'
            'greetings'
            'oi!'
            'attention!'
        ]
        exclamation.forEach((input)->
            it(input, (done)->
                intention.interpretAsync(input).done((res, err)->
                    if (err) then throw err
                    assert.strictEqual(res.type, 'dialog', "For input #{res.input}")
                    assert.strictEqual(res.isExclamation, true , "Not classified as exclamation #{res.input}")
                    assert.strictEqual(res.isQuestion, false )
                    done()
                )
            ))
    )
)