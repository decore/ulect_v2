###
#@author <Nikolay.Gerzhan@gmail.com>
###
define ['cs!./module'], (module)->
    module.directive "loadingContainer", [ ->
        restrict: "A"
        scope: false
        link: (scope, element, attrs) ->
            loadingLayer = angular.element("<div class=\"loading\"></div>")
            element.prepend loadingLayer
            element.addClass "loading-container"
            scope.$watch attrs.loadingContainer, (value) ->
                loadingLayer.toggleClass "ng-hide", not value
    ]