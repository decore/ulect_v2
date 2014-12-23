/**
 * Profile.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    attributes: {
        owner: {
            model: 'User',
            via: 'id',
            required: true
        },
        companyname: "string",
        country: {
            model: 'Country',
            via: 'id'
        },
        firstname: "string",
        lastname: "string",
        phone: "string"
        
    }
};

