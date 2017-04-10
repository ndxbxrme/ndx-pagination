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
      <div ng-repeat=\"myPage in (allPages = getPages())\" ng-click=\"setPage(myPage)\" ng-class=\"{selected:ngModel===myPage}\" ng-show=\"shouldShowPage(myPage)\" class=\"page number\">{{myPage}}</div>
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
      i = 0
      scope.totalPages = Math.ceil scope.total / scope.pageSize
      while i++ < scope.totalPages
        pages.push i
      pages
    scope.shouldShowPage = (page) ->
      pagesToShow = scope.pagesToShow or 5
      floorHalf = Math.floor pagesToShow / 2
      ceilHalf = Math.ceil pagesToShow / 2
      if scope.showAllPages or Math.abs(page - scope.ngModel) < ceilHalf or (page < (pagesToShow + 1) and scope.ngModel < (pagesToShow - 1)) or (page > scope.totalPages - pagesToShow and scope.ngModel > scope.totalPages - ceilHalf)
        return true
      scope.ellipsisPre = false
      scope.ellipsisPost = false
      if scope.ngModel > ceilHalf
        scope.ellipsisPre = true
      if scope.ngModel < scope.totalPages - floorHalf
        scope.ellipsisPost = true
      false
    scope.setPage = (page) ->
      scope.ngModel = page
      scope.pageChange?()? page