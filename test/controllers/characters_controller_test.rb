require 'test_helper'

class CharactersControllerTest < ActionController::TestCase
  setup do
    @character = characters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:characters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create character" do
    assert_difference('Character.count') do
      post :create, character: { anecdote: @character.anecdote, avatar_name: @character.avatar_name, avatar_url: @character.avatar_url, birth_date: @character.birth_date, birth_place: @character.birth_place, copyright: @character.copyright, first_name: @character.first_name, last_name: @character.last_name, resume: @character.resume, sex: @character.sex, small_rp: @character.small_rp, story: @character.story, topic_id: @character.topic_id, user_id: @character.user_id }
    end

    assert_redirected_to character_path(assigns(:character))
  end

  test "should show character" do
    get :show, id: @character
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @character
    assert_response :success
  end

  test "should update character" do
    patch :update, id: @character, character: { anecdote: @character.anecdote, avatar_name: @character.avatar_name, avatar_url: @character.avatar_url, birth_date: @character.birth_date, birth_place: @character.birth_place, copyright: @character.copyright, first_name: @character.first_name, last_name: @character.last_name, resume: @character.resume, sex: @character.sex, small_rp: @character.small_rp, story: @character.story, topic_id: @character.topic_id, user_id: @character.user_id }
    assert_redirected_to character_path(assigns(:character))
  end

  test "should destroy character" do
    assert_difference('Character.count', -1) do
      delete :destroy, id: @character
    end

    assert_redirected_to characters_path
  end
end
