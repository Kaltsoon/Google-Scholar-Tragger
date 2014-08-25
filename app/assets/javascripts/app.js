var searchApp = angular.module("SearchApp", []);

searchApp.service("UI", function(){
	return {
		fit_results_on_screen: function(count){
			var screen_height = $(window).height();
			var height_to_share = screen_height - $("#search-form").outerHeight(true) - ( 20 + 15 * count + 10); // body margin + 10 * margin + 10
			var height_for_each = height_to_share / count;

			$("#search-results-list .media").each(function(index){
				$(this).css("height", height_for_each + "px");
			});
		},

		set_iframe_dimensions: function(){
			$("#result-display-frame, #result-display-frame iframe").css({
				height: $(window).height()
			});
		},

		hide_iframe: function(){
			$("#result-display-frame").removeClass("bring-left");
		},		

		show_iframe: function(url){
			$("#result-display-frame, #result-display-frame iframe").css({
				height: $(window).height()
			});

			$("#result-display-frame iframe").attr("src", url);
			$("#result-display-frame").addClass("bring-left");
		},

		hide_menu: function(){
			$(".navbar").hide();
			$("body").css("padding-top", "20px");
		},

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
	var active_click = null;
	var results_on_screen = 7;

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
			$.post("/task_reports", { task_id: $scope.chosen_task.id, started: new Date() })
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
				$.post("/scholar_queries", { query_text: current_keyword, task_report_id: current_task_report_id, query_time: new Date() })
				.done(function(data){
					current_query_id = data.id;
				});
			});

		}

	}

	$scope.register_click = function(result){
		if(current_query_id != null){
			active_click = result;
			UI.show_iframe(result.link);
			$.post("/query_clicks", { scholar_query_id: current_query_id, heading: result.title, link_location: result.link, synopsis: result.synopsis, location: result.location, authors: result.authors, sitations: result.sitations, click_time: new Date() })
			.done(function(data){
				console.log("ID RECIEVED: " + data.id)
				active_click.id = data.id;
			});
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

	$scope.hide_result_display_frame = function(){
		UI.hide_iframe();
		$.post("/query_click_end", { id: active_click.id });
		active_click = null;
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
			UI.fit_results_on_screen(results_on_screen);
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

	var get_scroll_location = function(){
		return Math.max(0, $(document).scrollTop() - $("#search-form").outerHeight(true) - 20);
	}

	var register_scroll = function(){
		var location = get_scroll_location();

  		if(current_keyword != "" && $scope.results.length != 0 && location >= 0 && active_click == null){
  			scroll_buffer.push({
	    		location: location,
	    		time: new Date()
	    	});
  		}
	}

	fetch_tasks(function(){
		$("#task-container").fadeIn();
	});

	UI.set_iframe_dimensions();
	UI.hide_menu();
	UI.init_pagination({
		onPageClick: function(){
			fetch_results(function(){});
		}
	});

	$(window).scroll(function(){
		register_scroll();
	})

    $(document).ready(function(){
    	 $( "#slider-vertical" ).slider({
			orientation: "vertical",
			range: "min",
			min: 3,
			max: 10,
			value: 7,
			slide: function(event, slider){
				results_on_screen = slider.value;
				UI.fit_results_on_screen(results_on_screen);
			}
		});
    });
}]);