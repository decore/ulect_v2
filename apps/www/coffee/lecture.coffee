define [ 'backbone' ], (Backbone) ->
  lectureId = window.lectureId
  console.log lectureId
  class Lecture extends Backbone.Model
    #initialize: (@id)->
    #    console.log @id

    @baseUrl: '/api/v1/'

    urlRoot: -> Lecture.baseUrl+'/api/v1/lecture'

    #url: -> '/api/v1/lecture/'#"#{super}.json"
