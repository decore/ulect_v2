define [ 'underscore', 'backbone',  'log' ], (_, Backbone, log) ->

    class SliderShareView

        constructor: (@$el) ->
            @ready = no
            @iframe = ($el.find 'iframe')[0]
            #@ctx = @canvas.getContext '2d'

        setMaxHeight: (@maxHeight) -> @$el.height maxHeight

        load: (@url) =>
            console.debug "ser slaid share url", @url
            #@iframe.src = "#{@url}?jsapi=true"
            #$(@iframe).attr('src',"#{@url}?jsapi=true")
            @ready = yes

        #  PDFJS.getDocument(url).then @_onPDFReady

        #        _onPDFReady: (@pdfDoc) =>
        #            @ready = yes
        #            @displayPage 1 unless @pageNum?
        #
        #        displayPage: (pageNum) ->
        #            return if @pageNum is pageNum
        #            @pageNum = pageNum
        #            return unless @ready
        #            @pdfDoc.getPage(pageNum).then @_renderPage

        _renderPage: (page) =>
            log "displaying page", page

            scaleY = @maxHeight / page.view[3]
            scaleX = @$el.width() / page.view[2]
            scale = Math.min scaleX, scaleY

            log 'slideshare-view scaleX:', scaleX, 'scaleY:', scaleY, 'scale:', scale

            viewport = page.getViewport scale
            #      @canvas.width = viewport.width
            #      @canvas.height = viewport.height

            page.render 
                canvasContext: @ctx
                viewport: viewport
            .then do => @trigger 'rendered'

    _.extend SliderShareView.prototype, Backbone.Events

    return SliderShareView