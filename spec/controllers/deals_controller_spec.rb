require 'spec_helper'

describe DealsController do
  
  before :each do
    @current_user = mock_model(User)
    controller.stub(:current_user).and_return(@current_user)
  end

  describe "new" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should create a new deal" do
      deal = mock_model(Deal)
      Deal.should_receive(:new).and_return(deal)
      get 'new'
      
      assigns(:deal).should == deal
    end
  end
  
  describe "create" do
    it "should redirect to the index action if create successful" do
      post 'create', {:deal => deal_parameters}
      response.should redirect_to :controller => 'deals', :action => 'index'
    end
    
    it "should render the new template again if create was not successful" do
      post 'create', {:deal => {}}
      
      response.should render_template 'new'
    end
    
    it "should create a deal based on the submitted parameters" do
      post 'create', {:deal => deal_parameters}
      
      assigns(:deal).user.should == @current_user
      assigns(:deal).startup_name.should == 'equeety'
      assigns(:deal).website.should == 'equeety.com'
      assigns(:deal).contact_name.should == 'stefano'
      assigns(:deal).contact_email.should == 'me@email.com'
      assigns(:deal).required_amount == 111
      assigns(:deal).proposed_valuation == 222
    end
  end

  describe "index" do
    before do
      @deals = [mock_model(Deal), mock_model(Deal)]
      Deal.should_receive(:where).with(:user_id => @current_user).and_return(@deals)
    end
    
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    
    it "should find all deals owned by the current user" do
      get 'index' 
      assigns(:deals).should == @deals
    end
  end
  
  describe "edit" do
    it "should find the deal to edit" do
      deal = mock_model(Deal)
      Deal.should_receive(:find).with(1).and_return(deal)
      get 'edit', :id => 1
      
      assigns(:deal).should == deal
    end
  end
  
  describe "update" do
    before do
      @deal = mock_model(Deal)
      Deal.should_receive(:find).with(23).and_return(@deal)
    end
    it "should update the deal based on the submitted parameters" do
      @deal.should_receive(:update_attributes).with(deal_parameters)
      put 'update', :id => 23, :deal => deal_parameters
    end
    
    it "should redirect to index action if update successful" do
      @deal.stub(:update_attributes).and_return(true)
      put 'update', :id => 23
      
      response.should redirect_to :controller => 'deals', :action => 'index'
    end
    
    it "should render the edit template if update unsuccessful" do
      @deal.stub(:update_attributes).and_return(false)
      put 'update', :id => 23
      
      response.should render_template 'edit'
    end
  end
  
  private
  
  def deal_parameters
    {
      'startup_name' => 'equeety',
      'website' => 'equeety.com',
      'contact_name' => 'stefano',
      'contact_email' => 'me@email.com',
      'required_amount' => '111', 
      'proposed_valuation' => '222'
    }
  end
end
