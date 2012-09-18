require 'spec_helper'

describe ReservationsController do
    render_views

    
    describe "GET index" do
    
        it "should successfully index the reservations" do
            get :index
            response.should be_success
        end
    
    end
    
    describe "GET new" do
        it "should be successful" do
            get :new
            response.should be_success
        end
        
        it "should render the form" do
           get :new
           response.should render_template('reservations/new') 
        end
    end
    
    describe "POST create" do
       
       it "should redirect to the show page on successful save" do
           Reservation.any_instance.stubs(:valid?).returns(true)
           post :create
           response.should render_template('show')
       end
       
       it "should re-render new on failed save" do 
           Reservation.any_instance.stubs(:valid?).returns(false)
           post :create
           response.should render_template('new')
       end
        
        
    end
    
end