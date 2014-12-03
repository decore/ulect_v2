requirejs.config

  paths:
    'underscore'    : 'libs/underscore'
    'jquery'        : 'libs/jquery'
    'backbone'      : 'libs/backbone'
    'store'         : 'libs/store'
    #'pdfjs'         : 'libs/pdfjs/pdf'
    #'pdfjs-compat'  : 'libs/pdfjs/compatibility'

  shim:
    #    'pdfjs':
    #      deps: [ 'pdfjs-compat' ]
    #      init: ->
    #        @PDFJS.workerSrc = 'js/libs/pdfjs/pdf.worker.js'
    #        return @PDFJS

    'underscore':
      exports: '_'

    'backbone':
      deps: [ 'underscore', 'jquery' ]
      exports: 'Backbone'

define [ 'module', 'jquery', 'lecture', 'lecture-view', 'log' ], (module, $, Lecture, LectureView, log) ->
  config = module.config()

  Lecture.baseUrl = location.origin# config.baseUrl
  lecture = new Lecture id: window.lectureId#config.lecture
  lecture.fetch(id: window.lectureId)

  view = new LectureView model: lecture

  onYouTubeReady = ->
    log 'YouTube API initialized'
    view.initVideo()

  return { onYouTubeReady }