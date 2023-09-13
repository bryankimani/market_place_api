require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should show user" do
    get api_v1_user_path(@user), as: :json
    assert_response :success
    # Test to ensure response contains the correct email
    json_response = JSON.parse(self.response.body)
    assert_equal @user.email, json_response['email']
  end

  test "should create user" do
    assert_difference('User.count') do
      post api_v1_users_path, params: { user: { email: 'test@example.com', password: '123456' } }, as: :json
    end

    assert_response :created
  end

  test "should not create user with taken email" do
    assert_no_difference('User.count') do
      post api_v1_users_path, params: { user: { email: @user.email, password: '123456' } }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "Should update user" do
    patch api_v1_user_path(@user), params: { user: { email: @user.email, password: '123456' } }, as: :json
    assert_response :success
  end

  test "should not update user when invalid params are sent" do
    patch api_v1_user_path(@user), params: { user: { email: 'bad_email', password: '123456' } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete api_v1_user_path(@user), as: :json
    end

    assert_response :no_content # status code of 204
  end
end
