bcrypt = require('bcryptjs');
crypto = require('crypto');
module.exports = {

    ###
     * Generate a bcrypt hash from input
     * @param  {object}   options            object of options
     * @param  {string}   input              the input to be hashed
     * @param  {Function} cb[err, hash]      the callback to call when hashing is finished
    ###
    generate:  (options, input, cb)->
        saltComplexity = options.saltComplexity || 10;
        bcrypt.genSalt(saltComplexity,  (err, salt)->
            bcrypt.hash(input, salt,  (err, hash)->
                if(err)
                    return cb(err);
                return cb(null, hash);
            )
        )
    ###
    * Compares a given string against a hash,
    * Bcrypt.compare returns true/false whether
    * matches or not
    * @param  {string}   input          the string to use to compare
    * @param  {string}   hash           the hash to compare the input against
    * @param  {Function} cb[boolean]    the callback to call when comparision is done
    ###
    compare: (input, hash, cb)->
        console.log input, hash
        #cb(null,true)
        bcrypt.compare(input, hash, (err, match)->
            console.log  err, match
            return  cb('ok')
        #            if err
        #               return  cb(err);
        #            if match
        #               return cb(null, true);
        #            else
        #               return cb(err);
        )
        #        bcrypt.compare(input, hash,  (err, res)->
        #            return cb(res);
        #        )
    ###
    * Generate an md5 token from input
    * @param  {string}   input            the input to be hashed
    * @param  {Function} cb[err, hash]    the callback to call when hashing is finished
    ###
    token: (input)->
        hash = crypto.createHash('md5').update(input).digest('hex');
        return hash;
    genAPIkey: (id='')->
       key =  crypto.createHash('sha256').update(id).update('salt').digest('hex');#'06f905820cafb3b34bd7ba8729acf6d671446ff09ffb0aaa7f0290c936fc6c68'
       return key
}