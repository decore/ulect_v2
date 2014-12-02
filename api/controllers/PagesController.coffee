###
###
PagesController = {
    ###
    ###
    index:(req, res)->
        navItems =  {url: '/', cssClass: 'fa fa-comments', title: 'Главная'}
        queryCiteria =
            limit: 5
            sort : 'createdAt desc'
            where: {}
        Lecture.find(queryCiteria).exec(
            (err,entities)->
                if err
                    return res.serverError(err)
                res.view(
                    title: 'Главная'
                    navItems: navItems
                    currentUser: req.user
                    locales: sails.config.i18n.locales
                    lastLectures: entities
                )
        )

    ###
    About application
    ###
    about:(req, res)->
        navItems =  {url: '/about', cssClass: 'fa fa-comments', title: 'О сайте'}
        res.view(
            title: 'О сайте'
            navItems: navItems
            currentUser: req.user
            locales: sails.config.i18n.locales
        )

    ###

    ###
    courses_index:(req, res)->
        navItems =  {url: '/courses', cssClass: 'fa fa-comments', title: 'Курсы'}
        Course.find().exec(
            (err,entities)->
                if err
                    return res.serverError(err)
                console.log  entities
                res.view(
                    title: 'Курсы'
                    navItems: navItems
                    currentUser: req.user
                    locales: sails.config.i18n.locales
                    courses: entities
                )
        )
    courses_lectures_list :(req, res)->
        navItems =  {url: '/courses', cssClass: 'fa fa-comments', title: 'Курс'}
        console.log  'name course', req.param("name")
        _criteria =
            where:
                or: [
                    name: req.param("name")
                ]

        Course.findOne(_criteria).populate('lectures').exec(
            (err,entity)->
                if err
                    return res.serverError()
                console.log  entity
                res.view(
                    title: 'Курс'
                    navItems: navItems
                    currentUser: req.user
                    locales: sails.config.i18n.locales
                    course: entity
                )
        )



    ###
    ###
    lectures_index:(req, res)->
        navItems =  {url: '/lectures', cssClass: 'fa fa-comments', title: 'Лекции'}
        Lecture.find().exec(
            (err,entities)->
                if err
                    return res.serverError(err)
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
        navItems =  {url: '/lectures', cssClass: 'fa fa-comments', title: 'Лекция'}
        #console.log 'videoId play', req.param("videoId")
        #console.log 'slideshareId play', req.param("slideshareId")
        _criteria =
            where:
                or: [
                    videoId: req.param("videoId")
                ,
                    slideshareId: req.param("slideshareId")
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