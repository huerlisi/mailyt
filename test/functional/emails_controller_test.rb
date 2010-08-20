require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  setup do
    @email = emails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create email" do
    assert_difference('Email.count') do
      post :create, :email => @email.attributes
    end

    assert_redirected_to email_path(assigns(:email))
  end

  test "should show email" do
    get :show, :id => @email.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @email.to_param
    assert_response :success
  end

  test "should update email" do
    put :update, :id => @email.to_param, :email => @email.attributes
    assert_redirected_to email_path(assigns(:email))
  end

  test "should destroy email" do
    assert_difference('Email.count', -1) do
      delete :destroy, :id => @email.to_param
    end

    assert_redirected_to emails_path
  end
end
