(function() {
/*  
 * coffeescript_helpers 
 * NOTE: need for create classies  
 */
var __slice = Array.prototype.slice;
var __hasProp = Object.prototype.hasOwnProperty;
var __bind = function(fn, me) {
    return function() {
        return fn.apply(me, arguments);
    };
};
var __extends = function(child, parent) {
    for (var key in parent) {
        if (__hasProp.call(parent, key))
            child[key] = parent[key];
    }
    function ctor() {
        this.constructor = child;
    }

    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
};
var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
        if (this[i] === item)
            return i;
    }
    return -1;
};

//console.log = function(){};
//console.warn = function(){};
/**
 * A module representing a Admin Relevano.
 * @module RelevanoAdmin
 */

