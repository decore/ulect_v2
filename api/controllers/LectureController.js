/**
 * LectureController
 *
 * @description :: Server-side logic for managing lectures
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */
var dataMigrate = [
    {
        id: 1,
        createdAt: "2014-11-28T09:59:30.461Z",
        updatedAt: "2014-11-29T07:51:02.273Z",
        title: "Лекции Бизнес Инкубатора ВШЭ - Кейсы предпринимателей - Михаил Зарин, Антон Смирнов",
        slideId: "42151845",
        videoId: "IXqGHBHCbV4"
    }
];
module.exports = {
    migrate: function (req, res) {
        Lecture.create(dataMigrate,function(err,entites){
              if (err) return res.serverError(err);
              return res.json(entites);
          });      
        }
}
