define [ 'underscore', 'backbone', 'log' ], (_, Backbone, log) ->

  PRECISION_SEC = 0.1
  SECS = [60, 60, 24]

  # Converts 'dd:hh:mm:ss' string into the number of seconds
  parseTime = (timeStr) ->
    hms = timeStr.split ':'

    t = 0; i = 0; m = 1
    l = hms.length

    while i < l
      t += m * hms[l - i - 1]
      m *= SECS[i++]

    return t

  zeroPad = (n) -> if n < 10 then '0' + n else '' + n

  getTimeString = ->
    s = Math.round @time
    h = Math.floor s / (60 * 60)
    s -= 60 * 60 * h
    m = Math.floor s / 60
    s -= 60 * m
    if h > 0
      return "#{zeroPad h}:#{zeroPad m}:#{zeroPad s}"
    else "#{zeroPad m}:#{zeroPad s}"

  class Timeline

    constructor: (@slides, @duration) ->
      @_fixSlides()
      @currentIndex = -1
      @slide = null
      @start = 0
      @finish = @slides[0].time

    _fixSlides: ->
      duration = @duration

      for slide, index in @slides
        slide.index = index
        slide.time = parseTime slide.time
        slide.getTimeString = getTimeString
        slide.timePercent = slide.time / duration

      return

    _setCurrentIndex: (index) ->
      @currentIndex = index
      slides = @slides
      slide = slides[index]
      @slide = slide
      @start = slide.time
      @time = @start
      @finish = if index + 1 < slides.length
        slides[index + 1].time
      else Math.POSITIVE_INFINITY
      log 'Timeline::_setCurrentIndex', index, 'time interval ', @start, @finish

    updateTime: (@time) ->
      #log 'Timeline::updateTime', time
      unless @start - PRECISION_SEC < time < @finish + PRECISION_SEC
        slides = @slides
        total = slides.length
        i = 0
        while i < total - 1
          nextSlide = slides[i + 1]
          if time < nextSlide.time
            break
          ++i
        @_setCurrentIndex i
        @trigger 'change:slide', @slide, no

    gotoSlideWithIndex: (index) ->
      log 'Timeline::gotoSlideWithIndex', index
      return if index is @currentIndex or @slides.length is 0
      @_setCurrentIndex Math.max 0, Math.min @slides.length - 1, index
      @trigger 'change:slide', @slide, yes

    gotoNextSlide: -> @_gotoSlideRel +1
    gotoPrevSlide: -> @_gotoSlideRel -1

    _gotoSlideRel: (d) ->
      index = Math.max 0, Math.min @slides.length - 1, @currentIndex + d
      @gotoSlideWithIndex index

    getTimeString: getTimeString

  _.extend Timeline::, Backbone.Events

  Timeline