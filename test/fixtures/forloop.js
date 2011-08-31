/*jslint white: false, nomen: false, onevar: false */

/**
 * This code should run clean on jslint but in ref 27fa307eb8a132c67db78502d3f3c80b6128d6d5
 * the jslint code ported from jslint-johnson (which was modified slightly from
 * Douglas Crockford's JSLint Rhino code) fails under V8 - saying the following error:
 *
 * test/fixtures/forloop.js:
 *    line 19 character 11 Cannot set property 'first' of undefined
 */

function defineNamespace(namespace_string) {
  var names = namespace_string.split(".");
  
  var createdSomething = false;
  
  var parentObject = function(){ return this; }.call(null);
  
  for(var i = 0; i < names.length; i += 1) {
    var name = names[i];
    
    if(typeof(parentObject[name]) === "undefined") {
      createdSomething = true;
      parentObject[name] = {};
    }
    
    parentObject = parentObject[name];
  }
  
  return createdSomething;
}