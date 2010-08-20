require 'test_helper'

class MailsControllerTest < ActionController::TestCase
  setup do
    @mail = mails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail" do
    assert_difference('Mail.count') do
      post :create, :mail => @mail.attributes
    end

    assert_redirected_to mail_path(assigns(:mail))
  end

  test "should show mail" do
    get :show, :id => @mail.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mail.to_param
    assert_response :success
  end

  test "should update mail" do
    put :update, :id => @mail.to_param, :mail => @mail.attributes
    assert_redirected_to mail_path(assigns(:mail))
  end

  test "should destroy mail" do
    assert_difference('Mail.count', -1) do
      delete :destroy, :id => @mail.to_param
    end

    assert_redirected_to mails_path
  end
end
