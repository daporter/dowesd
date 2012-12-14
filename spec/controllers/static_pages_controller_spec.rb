require 'spec_helper'

describe StaticPagesController do
  describe '#home' do
    context 'when user is signed in' do
      it "redirects to the user's accounts page" do
        user = FactoryGirl.create(:user)
        controller.stub(:current_user).and_return(user)
        get :home
        response.should redirect_to(user_accounts_path(user))
      end
    end

    context 'when user is not signed in' do
      it 'renders the "home" template' do
        get :home
        response.should render_template(:home)
      end
    end
  end
end
