require 'spec_helper'

describe Reservation do 
    
    before(:each) do       
        @attr = {
            :name => "Guest1",
            :num_guests => 2,
            :start_time => "Fri, 21 Sep 2012 18:00:00 UTC +00:00"
        }
        
    end
    
    
    it "should require a name" do
        reservation = Reservation.create(@attr.merge(:name => ""))
        reservation.should have(1).error_on(:name)
    end
    
    it "should require num_guests" do
        reservation = Reservation.create(@attr.merge(:num_guests => ""))
        reservation.should_not be_valid
    end
    
    it "should require start_time" do
        reservation = Reservation.create(@attr.merge(:start_time => ""))
        reservation.should_not be_valid
    end
    
    it "should require a future start_time" do
        reservation = Reservation.create(@attr.merge(:start_time => "Fri, 15 Sep 2012 18:00:00 UTC +00:00"))
        reservation.should_not be_valid
    end
    
    it "should reject num_guests out of the range 1..4" do
       reservation = Reservation.create(@attr.merge(:num_guests => 5))
       reservation.should_not be_valid 
    end
    
    it "should reject non-integers for num_guests" do
       reservation = Reservation.create(@attr.merge(:num_guests => "num")) 
       reservation.should_not be_valid
    end
    
    it "should find the table_reserved for a valid reservation" do
       reservation = Reservation.create(@attr) 
       reservation.table_reserved.should_not be_nil
    end
    
    it "should reserve table 1(when both available) for 1..2 guests " do
       reservation = Reservation.create(@attr) 
       reservation.table_reserved.should equal 1
    end
    
    it "should reserve table 2(when both available) for 3..4 guests " do
       reservation = Reservation.create(@attr.merge(:num_guests => 3)) 
       reservation.table_reserved.should equal 2
    end
    
    it "should reserve table 2(only available) for 1..2 guests " do
       reservation1 = Reservation.create(@attr)   
       reservation2 = Reservation.create(@attr) 
       reservation2.table_reserved.should equal 2
    end
    
    it "should reject an invalid start_time" do
       reservation = Reservation.create(@attr.merge(:start_time => "Fri, 21 Sep 2012 15:00:00 UTC +00:00")) 
       reservation.should have(1).error_on(:start_time)
    end
    
    it "should reject an invalid start_time" do
       reservation = Reservation.create(@attr.merge(:start_time => "Fri, 21 Sep 2012 15:00:00 UTC +00:00")) 
       reservation.should have(1).error_on(:start_time)
    end
    
    it "should reject reservation request both the tables are taken" do
       reservation1 = Reservation.create(@attr)
       reservation2 = Reservation.create(@attr)
       lambda {Resevation.create(@attr)}.should raise_error
    end
    
    
end