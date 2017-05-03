'use strict'
module = null
try
  module = angular.module 'ndx'
catch e
  module = angular.module 'ndx', []
module
.directive 'pagination', ->
  restrict: 'AE'
  require: 'ngModel'
  template: "
    <div ng-show=\"totalPages &gt; 1\" class=\"pagination\">
      <style type=\"text/css\">.pagination {display: flex;}.pagination .page {padding: 0.5rem;min-width: 1.2rem;cursor: pointer;user-select: none;}.pagination .page.selected {color: #f00;}.pagination .page.disabled {opacity: 0.5;pointer-events: none;}</style>
      <div ng-click=\"setPage(ngModel - 1)\" ng-class=\"{disabled:ngModel&lt;2}\" ng-hide=\"hidePrevNext\" class=\"page prev\">{{prevText}}</div>
      <div ng-click=\"setPage(1)\" ng-show=\"showFirstLast\" class=\"page first\">{{firstText}}</div>
      <div ng-show=\"ellipsisPre\" class=\"page ellipsis pre\">{{ellipsisText}}</div>
      <div ng-repeat=\"myPage in (allPages = getPages())\" ng-click=\"setPage(myPage)\" ng-class=\"{selected:ngModel===myPage}\" class=\"page number\">{{myPage}}</div>
      <div ng-show=\"ellipsisPost\" class=\"page ellipsis post\">{{ellipsisText}}</div>
      <div ng-click=\"setPage(totalPages)\" ng-show=\"showFirstLast\" class=\"page last\">{{lastText}}</div>
      <div ng-click=\"setPage(ngModel + 1)\" ng-class=\"{disabled:ngModel&gt;totalPages-1}\" ng-hide=\"hidePrevNext\" class=\"page next\">{{nextText}}</div>
    </div>"
  replace: true
  scope:
    ngModel: '='
    pageSize: '='
    total: '='
    showFirstLast: '='
    firstText: '@'
    lastText: '@'
    showAllPages: '='
    pagesToShow: '='
    hidePrevNext: '='
    prevText: '@'
    nextText: '@'
    ellipsisText: '@'
    pageChange: '&'
  link: (scope, elem) ->
    scope.totalPages = 0
    scope.getPages = ->
      scope.firstText = scope.firstText or 'First'
      scope.lastText = scope.lastText or 'Last'
      scope.prevText = scope.prevText or '<<'
      scope.nextText = scope.nextText or '>>'
      scope.ellipsisText = scope.ellipsisText or '..'
      pages = []
      pagesToShow = scope.pagesToShow or 5
      i = Math.max 0, scope.ngModel - Math.ceil(pagesToShow / 2)
      end = i + pagesToShow
      scope.totalPages = Math.ceil scope.total / scope.pageSize
      if end > scope.totalPages
        end = scope.totalPages
        i = Math.max 0, end - pagesToShow
      scope.ellipsisPre = false
      if i > 0
        scope.ellipsisPre = true
      scope.ellipsisPost = false
      if i + pagesToShow < scope.totalPages
        scope.ellipsisPost = true
      while i++ < Math.min scope.totalPages, end
        pages.push i
      pages
    scope.setPage = (page) ->
      scope.ngModel = page
      scope.pageChange?()? page