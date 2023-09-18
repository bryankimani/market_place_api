require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should show user" do
    get api_v1_user_path(@user), as: :json
    assert_response :success
    # Test to ensure response contains the correct email
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @user.email, json_response.dig(:data, :attributes, :email)
    assert_equal @user.products.first.id.to_s, json_response.dig(:data, :relationships, :products, :data, 0, :id)
    assert_equal @user.products.first.title, json_response.dig(:included, 0, :attributes, :title, :title)
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
    patch api_v1_user_path(@user),
      params: { user: { email: @user.email } },
      headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
      as: :json
    assert_response :success
  end

  test "should forbid update user" do
    patch api_v1_user_path(@user),
      params: { user: { email: @user.email } }, as: :json
    assert_response :forbidden
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete api_v1_user_path(@user),
        headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
        as: :json
    end

    assert_response :no_content # status code of 204
  end

  test "should forbid destroy user" do
    assert_no_difference('User.count') do
      delete api_v1_user_path(@user), as: :json
    end

    assert_response :forbidden
  end
end
