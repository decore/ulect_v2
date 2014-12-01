define [ 'underscore', 'jquery', 'backbone', 'log' ], (_, $, Backbone, log) ->

  class SlidesView extends Backbone.View

    events:
      'click .slide': '_onSlideClicked'

    initialize: ->
      @timeline = @model.get 'timeline'
      @slideshare = @model.get 'slideshareUrl' ##NOTE: url to slideshareslideshareUrl
      console.debug @slideshare
      @listenTo @timeline, 'change:slide', @_onSlideChanged
      $(window).resize _.debounce @updateSize, 300

    render: ->
      @$el.empty()

      timeline = @timeline
      slides = timeline.slides

      $slides = []
      $timeLabels = []
      timeLabelsWidths = []

      maxTimeLabelW = 0

      for slide in slides
        html = "<a title=\"#{ slide.title }\" href=\"javascript:void(0);\" class=\"slide col-xs-12 col-sm-12 col-lg-12\" data-index=\"#{ slide.index }\"><span class=\"time\">#{slide.getTimeString()}</span>#{ slide.title }</div>"
        $slide = $ html
        $slides[slide.index] = $slide
        @$el.append $slide
        $timeLabel = $slide.find '.time'
        $timeLabels[slide.index] = $timeLabel
        timeLabelW = $timeLabel.outerWidth()
        timeLabelsWidths[slide.index] = timeLabelW
        maxTimeLabelW = timeLabelW if timeLabelW > maxTimeLabelW

      @slides = slides
      @$slides = $slides
      @$timeLabels = $timeLabels
      @timeLabelsWidths = timeLabelsWidths

      @updateSize()

    updateSize: =>
      h = $(window).height() - @$el.offset().top - 5 -60 #NOTE: fix -footer heigth
      @$el.height Math.max 0, h

      $timeLabels = @$timeLabels
      timeLabelsWidths = @timeLabelsWidths

      colLeft = null
      $colTimeLabels = []
      maxColTimeLabelW = 0

      updateColTimeLabels = ->
        #log 'column: l', l, 'lw', maxColTimeLabelW
        for $timeLabel in $colTimeLabels
          $timeLabel.css 'width', "#{ maxColTimeLabelW }px"
        $colTimeLabels = []
        maxColTimeLabelW = 0

      for $slide, i in @$slides
        continue unless $slide

        l = $slide.offset().left

        if colLeft is null
          colLeft = l
        else if l > colLeft + 5
          updateColTimeLabels()
          colLeft = l

        w = timeLabelsWidths[i]
        if w > maxColTimeLabelW
          maxColTimeLabelW = w

        $colTimeLabels.push $timeLabels[i]

      updateColTimeLabels()

    setTopPosition: (posInPx) ->
      @$el.css 'top', "#{ posInPx }px"

    _onSlideClicked: (e) ->
      $slideLink = $(e.target).closest '.slide'
      index = Number $slideLink.attr 'data-index'
      @timeline.gotoSlideWithIndex index

    _onSlideChanged: (slide) ->
      if @$curentSlide then @$curentSlide.removeClass 'selected'
      $slide = @$slides[slide.index]
      @$curentSlide = $slide
      $slide.addClass 'selected'

      dScroll = 0
      l = $slide.position().left

      if l < 0
        dScroll = l
      else
        r = l + $slide.outerWidth()
        vr = @$el.width()
        if r > vr
          dScroll = r - vr

      if dScroll != 0 then @$el.animate {
        scrollLeft: @$el.scrollLeft() + dScroll
      }, 250
