/**
 * LectureController
 *
 * @description :: Server-side logic for managing lectures
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */
var dataMigrate =  require( 'data_ulect_migrate');
module.exports = {
    migrate: function (req, res) {
        Lecture.create(dataMigrate,function(err,entites){
              if (err) return res.serverError(err);
              return res.json(entites);
          });      
        }
}
