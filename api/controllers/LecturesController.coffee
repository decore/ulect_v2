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

        #Lecture.create _params
        return res.json req.params.all()


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
                        _.each dataMigrate, (data)->
                                    courses[1].lectures.add data.id
                                    #_.extend data , course:courses[1].id
                        #                                    Lecture.create(data,
                        #                                        (err, enities)->
                        #                                            if err
                        #                                                return res.serverError(err)
                        #                                            AllEnities.push enities
                        courses[1].save()
                        #return  res.json courses
                        Lecture.destroy().exec(
                            (err,entities)->

                                _.each dataMigrate, (data)->
                                    data.course=courses[1].id
                                    #_.extend data , course:courses[1].id
                                    Lecture.create(data,
                                        (err, enities)->
                                            if err
                                                return res.serverError(err)
                                            AllEnities.push enities

                                    )

                                return  res.json AllEnities
                        )
                )
        )

}


module.exports =  LecturesController