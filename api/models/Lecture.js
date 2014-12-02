/**
 * Lecture.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    attributes: {
        title: {
            type: "string",
            required: true,
        },
        author: {
            type: "string",
            //required: true
        },
        videoId: {
            type: "string",
            required: true
        }, 
        slideshareId: { 
            type: "string",
            defaultsTo: "42152411"
        }, 
        slides: {
            type: "array"
        }
        ,
        course: {
            model: 'Course' 
        }
    }
};

