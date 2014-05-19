require 'test_helper'

class ScholarQueriesControllerTest < ActionController::TestCase
  setup do
    @scholar_query = scholar_queries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scholar_queries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scholar_query" do
    assert_difference('ScholarQuery.count') do
      post :create, scholar_query: { quering_time: @scholar_query.quering_time, query_text: @scholar_query.query_text }
    end

    assert_redirected_to scholar_query_path(assigns(:scholar_query))
  end

  test "should show scholar_query" do
    get :show, id: @scholar_query
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scholar_query
    assert_response :success
  end

  test "should update scholar_query" do
    patch :update, id: @scholar_query, scholar_query: { quering_time: @scholar_query.quering_time, query_text: @scholar_query.query_text }
    assert_redirected_to scholar_query_path(assigns(:scholar_query))
  end

  test "should destroy scholar_query" do
    assert_difference('ScholarQuery.count', -1) do
      delete :destroy, id: @scholar_query
    end

    assert_redirected_to scholar_queries_path
  end
end
