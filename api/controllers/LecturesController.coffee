###
###
navItems =   {url: '/about', cssClass: 'fa fa-comments', title: 'About'}
dataMigrate = require './data_ulect_migrate'
data = [

    author: "Бизнес-инкубатор ВШЭ"
    title: "Лекции Бизнес Инкубатора ВШЭ - Кейсы предпринимателей - Михаил Зарин, Антон Смирнов"
    slideId: "42151845"
    slideshareUrl: "//www.slideshare.net/slideshow/embed_code/42151845"
    videoId: "IXqGHBHCbV4"
,
    author: "Бизнес-инкубатор ВШЭ"
    title: "Лекции Бизнес Инкубатора ВШЭ - Лекция Юлии Молчановой"
    slideId: "42152411"
    slideshareUrl: "//www.slideshare.net/slideshow/embed_code/42152411"
    videoId: "AlKQcphwUQM"
]

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
    ###
    migrate: (req,res)->
        Lecture.destroy().exec(
         (err,entities)->
            Lecture.create(dataMigrate,
                (err, enities)->
                    if err
                        return res.serverError(err)
                    return res.json enities
            )
        )

}


module.exports =  LecturesController