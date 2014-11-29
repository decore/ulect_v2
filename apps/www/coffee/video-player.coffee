define [ 'underscore', 'jquery', 'backbone', 'log' ], (_, $, Backbone, log) ->

  class VideoPlayer extends Backbone.View

    initialize: (options) ->
      @vol = 100
      @ready = no
      @playing = no

      log 'VideoPlayer.initialize, video ID:', options.videoId

      @player = new YT.Player 'videoplayer', _.extend {
        width: String @$el.width()
        videoId: options.videoId
        playerVars:
          controls: 0
          modestbranding: 1
          showinfo: 0
          rel: 0
        events:
          onReady: =>
            @player.setVolume 0
            @player.playVideo()
          onStateChange: @_onPlayerStateChange
      }, options.ytOptions ? {}

    height: -> $( @player.getIframe() ).outerHeight()

    _onPlayerReady: ->
      log 'player ready'
      @player.pauseVideo()
      @player.seekTo 0
      @player.setVolume 100
      @ready = yes
      @trigger 'ready'

    _onPlayerStateChange: (state) =>
      unless @ready
        @duration = @player.getDuration()
        log 'player init: state ' + state.data + ', duration', @duration
        if @duration > 0 then @_onPlayerReady()
      else
        log '_onPlayerStateChange:', state
        @_setPlaying (state.data is YT.PlayerState.PLAYING)

    volume: (vol) ->
      if vol is undefined
        if @ready then @player.getVolume() else @vol
      else
        if @ready then @player.setVolume vol
        @vol = vol

    playPause: -> if @playing then @pause() else @play()

    play: ->
      return if @playing
      @player.playVideo()

    pause: ->
      return unless @playing
      @player.pauseVideo()

    seek: (p) ->
      sec = p * @duration
      log "VideoPlayer.seek, perc #{ p }, sec #{ sec } of #{ @duration }"
      @_setPlaying no, no
      @trigger 'sync', sec, @duration
      @player.seekTo sec, yes

    _setPlaying: (playing, notify = yes) ->
      return if @playing is playing
      @playing = playing

      if playing
        @_syncIntvId = setInterval @_onSync, 300
      else
        clearInterval @_syncIntvId

      if notify then @trigger 'playing', playing

    _onSync: =>
      t = @player.getCurrentTime()
      @time = t
      @trigger 'sync', t, @duration
