/**
 * Created by mmarino on 9/5/2014.
 */
angular.module( 'sailng.header', [
])
.controller( 'HeaderCtrl', ['$scope', '$state', 'config',function HeaderController( $scope, $state, config ) {
    $scope.currentUser = config.currentUser;

    var navItems = [{
        title: 'About',
        translationKey: 'navigation:about',
        url: '/about',
        cssClass: 'fa fa-tasks fa-lg'
    }, {
        title: 'About2',
        translationKey: 'navigation:about',
        url: '/about2',
        cssClass: 'fa fa-tasks fa-lg'
    }];

    $scope.navItems = navItems;
}]);