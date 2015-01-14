###*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
module.exports = {
    getProfile: (req,res)->
        _token = req.token
        id= req.param('id')
        Profile.findOne(owner:id).populate('owner').exec(
            (err,profile)->
                if err
                    return res.json err
                else
                    res.json profile
        )


    saveProfile : (req,res)->
        id= req.param('id')

        params = req.params.all()

        if _.isObject params.owner
            User.update({id:id},{firstname:params.owner.firstname, lastname:params.owner.lastname},(err)->

            )
        params.owner.id = id
        Profile.findOrCreate({owner:id},params).exec(
            (err,profile)->
                if err
                    return res.json err
                else
                    if profile
                        profile.companyname = params.companyname
                        profile.phone = params.phone

                        profile.save(
                            (err)->
                                if err
                                    res.json err
                                else
                                    res.json profile
                        )
                    else
                         res.status 404
                         res.json user_msg:"Profile no created"

        )
}