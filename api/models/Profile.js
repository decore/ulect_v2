/**
 * Profile.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    schemas: true,
    attributes: {
        owner: {
            model: 'User',
            via: 'id',
            required: true
        },
        accountSid: {
            model: 'TwlAccount',
            via: 'sid'            
        },
        companyname: "string",
        country: {
            model: 'Country',
            via: 'ISO'
        },
        isoCountry: {
            type: "string",
        },
        countryISO: {
            type: "string"
        },
        phone: {
            type: "string"
        },
        phoneNumber: { 
            model: 'TwlPhoneNumber',
            via: 'sid'   
        },
        toJSON: function () {
            var obj = this.toObject();
              
             
            return obj;
        },
    }
};

