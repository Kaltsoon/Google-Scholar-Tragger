(function(){
	var searchApp = angular.module("SearchApp", []);

	searchApp.controller("SearchController", function($scope){

		$scope.results = [];
		$scope.loading = false;

		var current_query_id = null;
		var current_keyword = "";
		var feedback_target = null;

		$scope.search = function(){

			$("#pagination").pagination("enable");
			$("#pagination").pagination("selectPage", 1);

			if(current_query_id != null){
				ask_for_feedback();
			}

			current_keyword = $scope.keyword;

			fetch_results();
	
			$.post("/scholar_queries", { query_text: current_keyword }).
			done(function(data){
					current_query_id = data.id;
			});

		}

		$scope.register_click = function(result){
			if(current_query_id != null){
				$.post("/query_clicks", { scholar_query_id: current_query_id, heading: result.title, link_location: result.link, synopsis: result.synopsis, location: result.location, authors: result.authors, sitations: result.sitations });
			}
		}

		$scope.done = function(){
			if(current_query_id != null){

				ask_for_feedback();	

				$scope.results = [];
				$scope.keyword = "";
				current_keyword = "";

				$("#pagination").pagination("disable");

				current_query_id = null;
			}
		}

		$scope.give_feedback = function(){
			send_feedback();
		}

		var fetch_results = function(){

			$scope.loading = true;

			$("#pagination").pagination("disable");

			$scope.results = [];

			$.post("/query", { keyword: current_keyword, start: get_start() })
			.done(function(data){
				
				$scope.results = data.results;
				var location_pointer = get_page() * 10 + 1;
				$scope.results.forEach(function(result){
					result.location = location_pointer++;
				});
				$("#pagination").pagination("enable");
				$scope.loading = false;
				$scope.$apply();
			})
			.fail(function(){
				alert("Something went wrong!")
			});
		}

		var get_start = function(){
			return get_page() * 10;
		}

		var get_page = function(){
			page = $("#pagination").pagination("getCurrentPage") - 1;
			return page;
		}

		var ask_for_feedback = function(){
			feedback_target = current_query_id;

			$("#feedback-modal").modal("show");
		}

		var send_feedback = function(){
			var broadness = $("input[name='broadness']:checked").val();
			var satisfaction = $("input[name='satisfaction']:checked").val();

			$.post("/feedback", { query_id: feedback_target, broadness: broadness, satisfaction: satisfaction })
			.always(function(){
				$("#feedback-modal").modal("hide");
			});
		}

		$("#pagination").pagination({
	        items: 200,
	        itemsOnPage: 10,
	        cssStyle: 'light-theme',
	        onPageClick: fetch_results
	    });

	    $("#pagination").pagination("disable");

	});
})();
