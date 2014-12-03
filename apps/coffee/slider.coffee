define [ 'jquery', './base-slider' ], ($, BaseSlider) ->

  class Slider extends BaseSlider

    initialize: ->
      super
      @$marks = @$el.find '.marks'
      @listenTo @model, 'change:timeline', @render

    render: ->
      super

      timeline = @model.get 'timeline'
      duration = timeline.duration

      marksHtmls = []

      for slide in timeline.slides
        time = slide.time
        timePercent = (Math.round 100 * 100 * time / duration) / 100
        marksHtmls.push "<div class=\"mark\" style=\"left: #{ timePercent }%\" data-title=\"#{ slide.title }\"></div>"

      @$marks.html marksHtmls.join '\n'

      @undelegateEvents()
      @delegateEvents()

      return