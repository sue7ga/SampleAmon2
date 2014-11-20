function MainCtrl($scope,$http){
  $http.get("/students/show").success(fucntion(data,status,headers,config){
    $scope.students = data;
  });
}
