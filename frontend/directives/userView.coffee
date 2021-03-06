angular.module("MagicStick.directives").directive "userView", ->
  restrict: "E"
  scope:
    "user": "&"
  templateUrl: "user.html"
  controller: [
    "$scope"
    "$location"
    ($scope, $location, user) ->
      $scope.view = ->
        $location.path('/users/' + $scope.user().username)
  ]
