"use strict";
var AttachingEngineToDOM = new TestCase("When creating a new engine with the DOMParent parameter passed");

(function(){
    AttachingEngineToDOM.prototype["test that the engine attaches to a given DOM element and creates input and output elements"]=function(){
        var element = document.createElement("div"),
            Subject = new Game.Engine({
                DOMParent:element
            });
        assertTrue($(element).find("#input").length>0);
        assertTrue($(element).find("#output").length>0);
    };

    AttachingEngineToDOM.prototype["test that the engine attached to given DOM ID and creates input and output elements"]=function(){
        /*:DOC += <div id="container">some text</div> */
        var Subject = new Game.Engine({
                DOMParent:"container"
            });

        assertTrue($("#input").length>0);
        assertTrue($("#output").length>0);
    };
}());