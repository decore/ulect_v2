###
###
PagesController = {
    ###
    ###
    index:(req, res)->
        navItems =  {url: '/', cssClass: 'fa fa-comments', title: 'Главная'}
        res.view(
            title: 'Главная'
            navItems: navItems
            currentUser: req.user
            locales: sails.config.i18n.locales
        )
    ###

    ###
    courses_index:(req, res)->
        navItems =  {url: '/', cssClass: 'fa fa-comments', title: 'Курсы'}
        res.view(
            title: 'Курсы'
            navItems: navItems
            currentUser: req.user
            locales: sails.config.i18n.locales
        )
    ###
    ###
    lectures_index:(req, res)->
        navItems =  {url: '/', cssClass: 'fa fa-comments', title: 'Лекции'}
        Lecture.find().exec(
            (err,entities)->
                if err
                    return res.serverError()
                res.view(
                    title: 'Лекции'
                    navItems: navItems
                    currentUser: req.user
                    locales: sails.config.i18n.locales
                    lectures: entities
                )
        )
    ###
    ###
    lectures_play:(req, res)->
        navItems =  {url: '/', cssClass: 'fa fa-comments', title: 'Лекция'}
        console.log 'lecture play', req.param("videoId")
        _criteria =
            where:
                or: [
                    videoId: req.param("videoId")
                ,
                    title: req.param("slug")
                ]
                 
        Lecture.findOne(_criteria).exec(
            (err,entity)->
                if err
                    return res.serverError()
                console.log entity

                res.view(
                    title: 'Лекция'
                    navItems: navItems
                    currentUser: req.user
                    locales: sails.config.i18n.locales
                    lecture: entity
                )
        )



}
module.exports =  PagesController