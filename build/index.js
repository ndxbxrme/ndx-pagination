(function() {
  'use strict';
  var e, error, module;

  module = null;

  try {
    module = angular.module('ndx');
  } catch (error) {
    e = error;
    module = angular.module('ndx-pagination', []);
  }

  module.directive('pagination', function() {
    return {
      restrict: 'AE',
      require: 'ngModel',
      template: "<div ng-show=\"totalPages &gt; 1\" class=\"pagination\"> <style type=\"text/css\">.pagination {display: flex;}.pagination .page {padding: 0.5rem;min-width: 1.2rem;cursor: pointer;user-select: none;}.pagination .page.selected {color: #f00;}.pagination .page.disabled {opacity: 0.5;pointer-events: none;}</style> <div ng-click=\"setPage(ngModel - 1)\" ng-class=\"{disabled:ngModel&lt;2}\" ng-hide=\"hidePrevNext\" class=\"page prev\">{{prevText}}</div> <div ng-click=\"setPage(1)\" ng-show=\"showFirstLast\" class=\"page first\">{{firstText}}</div> <div ng-show=\"ellipsisPre\" class=\"page ellipsis pre\">...</div> <div ng-repeat=\"myPage in (allPages = getPages())\" ng-click=\"setPage(myPage)\" ng-class=\"{selected:ngModel===myPage}\" ng-show=\"shouldShowPage(myPage)\" class=\"page number\">{{myPage}}</div> <div ng-show=\"ellipsisPost\" class=\"page ellipsis post\">...</div> <div ng-click=\"setPage(totalPages)\" ng-show=\"showFirstLast\" class=\"page last\">{{lastText}}</div> <div ng-click=\"setPage(ngModel + 1)\" ng-class=\"{disabled:ngModel&gt;totalPages-1}\" ng-hide=\"hidePrevNext\" class=\"page next\">{{nextText}}</div> </div>",
      replace: true,
      scope: {
        ngModel: '=',
        pageSize: '=',
        total: '=',
        showFirstLast: '=',
        firstText: '@',
        lastText: '@',
        showAllPages: '=',
        pagesToShow: '=',
        hidePrevNext: '=',
        prevText: '@',
        nextText: '@',
        ellipsisText: '@',
        pageChange: '&'
      },
      link: function(scope, elem) {
        scope.totalPages = 0;
        scope.getPages = function() {
          var i, pages;
          scope.firstText = scope.firstText || 'First';
          scope.lastText = scope.lastText || 'Last';
          scope.prevText = scope.prevText || '<<';
          scope.nextText = scope.nextText || '>>';
          scope.ellipsisText = scope.ellipsisText || '..';
          pages = [];
          i = 0;
          scope.totalPages = Math.ceil(scope.total / scope.pageSize);
          while (i++ < scope.totalPages) {
            pages.push(i);
          }
          return pages;
        };
        scope.shouldShowPage = function(page) {
          var ceilHalf, floorHalf, pagesToShow;
          pagesToShow = scope.pagesToShow || 5;
          floorHalf = Math.floor(pagesToShow / 2);
          ceilHalf = Math.ceil(pagesToShow / 2);
          if (scope.showAllPages || Math.abs(page - scope.ngModel) < ceilHalf || (page < (pagesToShow + 1) && scope.ngModel < (pagesToShow - 1)) || (page > scope.totalPages - pagesToShow && scope.ngModel > scope.totalPages - ceilHalf)) {
            return true;
          }
          scope.ellipsisPre = false;
          scope.ellipsisPost = false;
          if (scope.ngModel > ceilHalf) {
            scope.ellipsisPre = true;
          }
          if (scope.ngModel < scope.totalPages - floorHalf) {
            scope.ellipsisPost = true;
          }
          return false;
        };
        return scope.setPage = function(page) {
          scope.ngModel = page;
          if (scope.pageChange) {
            return scope.pageChange()(page);
          }
        };
      }
    };
  });

}).call(this);

//# sourceMappingURL=index.js.map
