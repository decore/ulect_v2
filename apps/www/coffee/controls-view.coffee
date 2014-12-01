define [ 'jquery', 'backbone', 'log' ], ($, Backbone, log) ->

  class ControlsView extends Backbone.View

    initialize: ->
      @$playPause = @$el.find '.playpause'
      @$time = @$el.find '.time'
      @$totalSlides = @$el.find '.total'
      @$currentSlide = @$el.find '.current'

    events:
      'click .prev': -> @trigger 'prev'
      'click .next': -> @trigger 'next'
      'click .playpause': -> @trigger 'playpause'

    render: ->
      @timeline = @model.get 'timeline'
      @$totalSlides.html @timeline.slides.length
      @$currentSlide.html '--'

      @listenTo @timeline, 'change:slide', @_onSlideChanged

    _onSlideChanged: (slide) -> @$currentSlide.html slide.index + 1

    setIsPlaying: (isPlaying) ->
      if isPlaying
        @$playPause.removeClass 'fa-play'
        @$playPause.removeClass 'icon-play'##TODO:delete
        @$playPause.addClass 'fa-pause'
        @$playPause.addClass 'icon-pause'##TODO:delete
      else
        @$playPause.removeClass 'fa-pause'
        @$playPause.removeClass 'icon-pause'##TODO:delete
        @$playPause.addClass 'fa-play'
        @$playPause.addClass 'icon-play'##TODO:delete



    setTimeString: (ts) ->
      return if ts is @ts
      @$time.html ts
      @ts = ts