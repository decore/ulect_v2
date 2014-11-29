define [ 'jquery', 'backbone' ], ($, Backbone) ->

  class BaseSlider extends Backbone.View

    initialize: ->
      @$handle = @$el.find '.handle'
      @$viewed = @$el.find '.viewed'
      @moving = no

    render: ->

    events:
      'mousedown': '_startMotion'

    _startMotion: (evt) =>
      @moving = yes

      @_updatePosition evt, no

      $(document).on 'mousemove', @_move
      $(document).on 'mouseup', @_stopMotion

      return false

    _move: (evt) =>
      @_updatePosition evt, no

    _stopMotion: (evt) =>
      $(document).off 'mousemove', @_move
      $(document).off 'mouseup', @_stopMotion

      @_updatePosition evt, yes
      @moving = no

    _updatePosition: (evt, finalize) ->
      x = evt.pageX - @$el.offset().left
      w = @$el.width()
      x = Math.max 0, Math.min w, x
      @_setHandlePosition x
      @position = p = x / w
      @trigger 'change', p if finalize

    _setHandlePosition: (x) ->
      rx = Math.round x
      @$handle.css 'left', "#{ rx }px"
      @$viewed.css 'width', "#{ rx }px"

    setPosition: (p, triggerEvt = no) ->
      return if @moving
      x = @$el.width() * p
      @_setHandlePosition x
      @trigger 'change', p if triggerEvt