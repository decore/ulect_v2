/**
 * Profile.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    schemas:true,    
    attributes: {
        owner: {
            model: 'User',
            via: 'id',
            required: true
        },
        companyname: "string",
        country: {
            model: 'Country',
            via: 'ISO'
        },
        countryISO:  {
            type:"string"
        },
        phone: {
            type:"string"
        },
        phoneNumber:{
            type:"string",
            defaultsTo:"+18303550804"
        }
        
    }
};

