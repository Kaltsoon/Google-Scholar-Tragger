var searchApp = angular.module("SearchApp", []);

searchApp.service("UI", function(){
	return {
		init_pagination: function(options){

			$("#pagination").pagination({
		        items: 400,
		        itemsOnPage: 40,
		        cssStyle: 'light-theme',
		        onPageClick: function(){
		        	$("html, body").animate({ scrollTop: 0 }, "slow");
		        	options.onPageClick();
		        }
		    });

		    $("#pagination").pagination("disable");
		},

		current_pagination_page: function(){

			return $("#pagination").pagination("getCurrentPage");
		},

		chosen_task_or: function(default_task){

			return $("input[type='radio'][name='task']:checked").val() || default_task
		},

		chosen_api_or: function(default_api){

			return $("input[type='radio'][name='resource']:checked").val() || default_api
		}
	}
});

searchApp.controller("SearchController", ["$scope", "UI", function($scope, UI){

	$scope.results = [];
	$scope.loading = false;
	$scope.error = false;
	$scope.no_results = false;
	$scope.tasks = [];
	$scope.chosen_task = null;
	$scope.task_report = null;

	var api = "arxiv"
	var task_id = null;
	var current_query_id = null;
	var current_keyword = "";
	var current_task_report_id = null;
	var feedback_target = null;
	var scroll_buffer = [];

	$scope.choose_task = function(){
		var chosen_id = UI.chosen_task_or($scope.tasks[0]);
		$scope.tasks.forEach(function(task){
			if(task.id == chosen_id){
				$scope.chosen_task = task;
				return;
			}
		});

		$("#task-container").slideUp(500, function(){
			$.post("/task_reports", { task_id: $scope.chosen_task.id })
			.done(function(data){
				current_task_report_id = data.task_report_id;
				$("#search-container").fadeIn(500);
			});
		});
	}

	$scope.search = function(){
		api = UI.chosen_api_or("arxiv");

		if($scope.keyword.trim() != ""){

			if(current_query_id != null){
				send_scroll_data();
				ask_for_feedback();
			}

			current_keyword = $scope.keyword;

			$("#pagination").pagination("enable");
			$("#pagination").pagination("drawPage", 1);

			fetch_results(function(){
				$.post("/scholar_queries", { query_text: current_keyword, task_report_id: current_task_report_id })
				.done(function(data){
					current_query_id = data.id;
				});
			});

		}

	}

	$scope.register_click = function(result){
		if(current_query_id != null){
			$.post("/query_clicks", { scholar_query_id: current_query_id, heading: result.title, link_location: result.link, synopsis: result.synopsis, location: result.location, authors: result.authors, sitations: result.sitations });
		}
	}

	$scope.done = function(){
		if(current_query_id != null){
			send_scroll_data();

			ask_for_feedback();	

			$("#pagination").pagination("disable");
			
			$("#search-container").slideUp(500, function(){
				$("#task-report-container").fadeIn(500);
			});

			current_query_id = null;

		}
	}

	$scope.give_feedback = function(){
		send_feedback();
	}

	$scope.send_task_report = function(){
		$.post("/send_task_report", { task_report_id: current_task_report_id, report: $scope.task_report, completed: new Date() })
		.always(function(){
			reset_variables();

			$("#task-report-container").slideUp(500, function(){
				fetch_tasks(function(){ $("#task-container").fadeIn(500) });
			});
		});
	}

	var reset_variables = function(){
		$scope.keyword = "";
		$scope.results = [];
		$scope.loading = false;
		$scope.error = false;
		$scope.no_results = false;
		$scope.tasks = [];
		$scope.chosen_task = null;
		$scope.task_report = null;

		api = "arxiv"
		task_id = null;
		current_query_id = null;
		current_keyword = "";
		current_task_report_id = null;
		feedback_target = null;
		scroll_buffer = [];

		$("#pagination").pagination("drawPage", 1);

		$scope.$apply();
	}

	var fetch_results = function(callback){
		$("#pagination").pagination("disable");

		$scope.results = [];
		$scope.loading = true;
		$scope.$apply();

		$.post("/query", { keyword: current_keyword, start: get_start(), resource: api })
		.done(function(data){
			$("#pagination").pagination("enable");

			callback();
			
			var location_pointer = get_page() * 40 + 1;

			$scope.results = data.results;
			$scope.error = false;

			if($scope.results.length > 0){
				$scope.no_results = false;
			}else{
				$scope.no_results = true;
			}

			$scope.results.forEach(function(result){
				result.location = location_pointer++;
			});		
		})
		.fail(function(){
			$scope.error = true;
		})
		.always(function(){
			$scope.loading = false;
			$scope.$apply();	
		});
	}

	var get_start = function(){
		return get_page() * 40;
	}

	var get_page = function(){
		page = UI.current_pagination_page() - 1;
		return page;
	}

	var ask_for_feedback = function(){
		feedback_target = current_query_id;

		$("#feedback-modal").modal("show");
	}

	var send_scroll_data = function(){
		$.post("/query_scroll", { query_id: current_query_id, scrolls: JSON.stringify(scroll_buffer)}).done(function(data){
			scroll_buffer = [];
		});
	}

	var send_feedback = function(){
		var broadness = $("input[name='broadness']:checked").val();
		var satisfaction = $("input[name='satisfaction']:checked").val();

		$.post("/feedback", { query_id: feedback_target, broadness: broadness, satisfaction: satisfaction })
		.always(function(){
			$("#feedback-modal").modal("hide");
		});
	}

	var fetch_tasks = function(callback){
		$.get("/users_tasks", function(data){
			$scope.tasks = data;
			$scope.chosen_task = data[0];
			$scope.$apply();

			callback();
		});
	}

	fetch_tasks(function(){
		$("#task-container").fadeIn();
	});

	UI.init_pagination({
		onPageClick: function(){
			fetch_results(function(){});
		}
	});

    $(window).bind("scroll", function(){
    	console.log($(document).scrollTop())
  		if(current_keyword != "" && $scope.results.length != 0){
  			scroll_buffer.push({
	    		location: $(document).scrollTop(),
	    		time: new Date()
	    	});
  		}
    });

}]);
