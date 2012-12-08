require 'spec_helper'

describe UsersController do
  describe 'GET index' do
    it 'redirects to signin page is user is not logged in' do
      get :index
      response.should redirect_to(signin_path)
    end
  end

  describe 'GET show' do
    it 'redirects to signin page is user is not logged in' do
      get :show, id: 1
      response.should redirect_to(signin_path)
    end
  end

  describe 'GET edit' do
    it 'redirects to signin page is user is not logged in' do
      get :edit, id: 1
      response.should redirect_to(signin_path)
    end
  end

  describe 'PUT update' do
    it 'redirects to signin page is user is not logged in' do
      put :update, id: 1
      response.should redirect_to(signin_path)
    end

    it "redirects to home page if user is not owner of profile" do
      user = stub(:user, id: 1)
      wrong_user = stub(:user, id: 2)
      User.stub(:find).with('1').and_return(user)
      controller.stub(:current_user).and_return(wrong_user)
      put :update, id: 1
      response.should redirect_to(root_path)
    end
  end
end
