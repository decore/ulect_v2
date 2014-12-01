define [
    'jquery'
    'backbone'
    'store'
    'timeline'
    'slidershare-view'##NOTE: SliderShareView
    'video-player'
    'base-slider'
    'slider'
    'slides-view'
    'controls-view'
    'log'
], (
    $
    Backbone
    store
    Timeline
    SliderShareView#NOTE: change PDFView
    VideoPlayer, BaseSlider, Slider, SlidesView, ControlsView, log) ->
    class SlidView extends Backbone.View
        initialize: ->
            #@listenTo @model, 'sync', @_onModelLoaded
            console.debug 'SlidView init'
            _.bindAll @, 'render','_onSlideChanged'

            #@timeline = @model.get 'timeline'
            console.debug 'asdf!!!  :)  !!!!asdf',@model.toJSON()
            @.model.bind 'change', @render
            #@.model.bind 'change:slide', @_onSlideChanged
            return
        el: $("#pdf-container")
        template: _.template '<iframe src="<%= slideshareUrl %>?jsapi=true" src3="//www.slideshare.net/slideshow/embed_code/42038461?jsapi=true" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe>'

        render: ->
            $(@el).html @.template(@.model.toJSON())
            #@listenTo @timeline, 'change:slide', @_onSlideChanged
            return @
        _onSlideChanged: (slide) =>
            console.debug '!!!!_onSlideChanged',slide,(@$el.find 'iframe')
            #@$currentSlide.html slide.index + 1
            (@$el.find 'iframe')[0].contentWindow.postMessage('jumpTo_'+slide.page,'*') #if !isJump
            return
    class LectureView extends Backbone.View

        initialize: ->
            #@iframe = $('#pdf-container iframe')
            @sliderView =   new SlidView(model:@model)
            #@pdfView = new PDFView $('#pdf-container')
            @sliderShareView = new SliderShareView $('#pdf-container')
            @listenTo @model, 'sync', @_onModelLoaded
            @listenTo @model, 'error', -> log 'model error:', arguments
            console.debug '@listenTo', @listenTo
        _onModelLoaded: =>
            log 'model loaded:', @model.attributes
            @modelLoaded = yes
            @_tryInitVideo()

        initVideo: ->
            log 'YouTube API ready'
            @youTubeAPIReady = yes
            @_tryInitVideo()

        _tryInitVideo: ->
            log "_tryInitVideo: model #{ @modelLoaded }, YouTube #{ @youTubeAPIReady }"

            return unless @modelLoaded and @youTubeAPIReady

            @player = new VideoPlayer
                el: '#videoplayer'
                videoId: @model.get 'videoId'

            @listenTo @player, 'ready', @_onPlayerReady

        _onPlayerReady: ->
            log 'player ready, video duration:', @player.duration
            @videoReady = yes
            @_init()

        _init: ->
            log '_init'
            log 'everything is ready, initializing timeline, loading PDF'

            slides = @model.get 'slides'
            @timeline = new Timeline slides, @player.duration
            @model.set 'timeline', @timeline

            @slider = new Slider
                model: @model
                el: '#slider'

            @volSlider = new BaseSlider
                el: '#vol-slider'

            @slides = new SlidesView
                model: @model
                el: "#slides"

            @controls = new ControlsView
                el: "#controls"
                model: @model

            @slider.render()
            @slides.render()
            @controls.render()

            #@pdfView.setMaxHeight @player.height()
            #@pdfView.load @model.get 'pdf'
            #@sliderShareView.setMaxHeight @player.height()
            @sliderShareView.load @model#.get 'slideshareUrl'

            @listenTo @timeline, 'change:slide', @_onSlideChanged
            @listenTo @player, 'sync', @_onPlayerSync
            @listenTo @slider, 'change', (p) -> @player.seek p

            @controls.on 'playpause', @player.playPause, @player
            @player.on 'playing', @controls.setIsPlaying, @controls

            @controls.on 'next', @timeline.gotoNextSlide, @timeline
            @controls.on 'prev', @timeline.gotoPrevSlide, @timeline

            if store.enabled
                log 'store enabled'
                getStoredVol = -> store.get 'volume'
                storeVol = (v) -> store.set 'volume', v
            else
                getStoredVol = ->
                storeVol = ->

            vol = getStoredVol()
            if vol
                vol = +vol
                @player.volume vol
            else
                vol = @player.volume()
                storeVol vol

            @volSlider.setPosition vol / 100
            @listenTo @volSlider, 'change', (p) ->
                vol = 100 * p
                storeVol vol
                @player.volume vol

            showUI = ->
                log 'actually showing UI'
                $('#loading').hide()

        #      @pdfView.once 'rendered', ->
        #        log 'PDF rendered, showing UI after delay'
        #        setTimeout showUI, 100
            @sliderShareView.once 'rendered', ->
                alert ''
                log 'sliderShareView rendered, showing UI after delay'
                setTimeout showUI, 100
            setTimeout showUI, 100
            return
        _onSlideChanged: (slide, isJump) ->
            console.debug "lecture-view:_onSlideChanged", slide, isJump
            #console.debug '#pdf-container iframe', @iframe
            @sliderView._onSlideChanged(slide)
            #$('iframe').get(0).contentWindow.postMessage('jumpTo_'+slide.page,'*') #if !isJump

            @slider.setPosition slide.timePercent
            @player.seek(slide.timePercent) if isJump
            #@pdfView.displayPage slide.page

        _onPlayerSync: (t, T) ->
            @slider.setPosition t / T
            @timeline.updateTime t
            @controls.setTimeString @timeline.getTimeString()

