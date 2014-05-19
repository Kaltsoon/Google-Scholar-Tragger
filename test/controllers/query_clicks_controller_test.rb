require 'test_helper'

class QueryClicksControllerTest < ActionController::TestCase
  setup do
    @query_click = query_clicks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:query_clicks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create query_click" do
    assert_difference('QueryClick.count') do
      post :create, query_click: { click_time: @query_click.click_time, heading: @query_click.heading, link_location: @query_click.link_location, scholar_query_id: @query_click.scholar_query_id, sitations: @query_click.sitations, synopsis: @query_click.synopsis }
    end

    assert_redirected_to query_click_path(assigns(:query_click))
  end

  test "should show query_click" do
    get :show, id: @query_click
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @query_click
    assert_response :success
  end

  test "should update query_click" do
    patch :update, id: @query_click, query_click: { click_time: @query_click.click_time, heading: @query_click.heading, link_location: @query_click.link_location, scholar_query_id: @query_click.scholar_query_id, sitations: @query_click.sitations, synopsis: @query_click.synopsis }
    assert_redirected_to query_click_path(assigns(:query_click))
  end

  test "should destroy query_click" do
    assert_difference('QueryClick.count', -1) do
      delete :destroy, id: @query_click
    end

    assert_redirected_to query_clicks_path
  end
end
