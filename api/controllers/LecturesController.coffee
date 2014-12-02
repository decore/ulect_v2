###
###
navItems =   {url: '/about', cssClass: 'fa fa-comments', title: 'About'}
dataMigrate = require './data_ulect_migrate'
dataMigrateCourses = require './data_ulect_courses'

LecturesController = {
    ###
    post event add new
    ###
    postDataLecture:(req, res)->
        navItems = navItems
        res.view(
            title: 'Добавление лекции'
            navItems: navItems
            currentUser: req.user
            locales: sails.config.i18n.locales
        )
    ###
    POST API
    ###
    saveLecture:(req, res)->
        _params = req.params.all()

        Lecture.create( _params, (err, data)->
            if err
                res.status 406
                return res.json err
            return res.json data
        )
    ###
    Migrate
    ###
    migrate: (req,res)->
        #dataMigrateCourses
        AllEnities = []
        Course.destroy().exec(
            (err, courses)->
                console.log 'destroy',courses
                Course.create(dataMigrateCourses).exec(
                    (err, courses)->
                        if err
                            return res.serverError(err)
                        x =0
                        _.each dataMigrate, (data)->
                                    if x < 5
                                       x = x+1
                                       courses[1].lectures.add data.id
                                    #_.extend data , course:courses[1].id
                        #                                    Lecture.create(data,
                        #                                        (err, enities)->
                        #                                            if err
                        #                                                return res.serverError(err)
                        #                                            AllEnities.push enities
                        courses[1].save(
                            (err,ok)->
                                if err
                                    return res.json err

                                #return  res.json courses
                                Lecture.destroy().exec(
                                    (err,entities)->
                                        if err
                                            return res.json err
                                        _.each dataMigrate, (data)->
                                            data.course=courses[1].id
                                            #_.extend data , course:courses[1].id

                                            Lecture.create(data,
                                                (err, enities)->
                                                    console.log enities
                                                    if err
                                                        return res.json err#serverError(err)
                                                    AllEnities.push enities

                                            )

                                        return  res.json AllEnities
                                )
                        )
                )
        )

}


module.exports =  LecturesController