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
        @$playPause.removeClass 'icon-play'
        @$playPause.addClass 'icon-pause'
      else
        @$playPause.removeClass 'icon-pause'
        @$playPause.addClass 'icon-play'

    setTimeString: (ts) ->
      return if ts is @ts
      @$time.html ts
      @ts = ts