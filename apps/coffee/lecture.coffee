define [ 'backbone' ], (Backbone) ->
  lectureId = window.lectureId
  class Lecture extends Backbone.Model 

    @baseUrl: '/api/v1/'

    urlRoot: -> Lecture.baseUrl+'/api/v1/lecture'

    #url: -> '/api/v1/lecture/'#"#{super}.json"
