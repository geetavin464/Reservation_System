class Reservation < ActiveRecord::Base
    
    validates :num_guests, :numericality => {:only_integer => true}
    validates :name, :num_guests, :presence => true
    validates :start_time, :presence => true, :allow_blank => false
    validates :table_reserved, :uniqueness => {:scope => :start_time, :message => "Reservation is not available at the requested time"}
    validate :start_time_in_restaurant_hours, :unless => Proc.new { |r| r.start_time.blank? }
    validate :num_guests_less_than_4
    
    before_create :reserve_table
    
    NUM_GUESTS_UPPER_LIMIT = 4
    START_TIME_LOW_LIMIT = 17      # 5 PM
    START_TIME_UPPER_LIMIT = 20    # 8 PM
    START_WDAY_LOW_LIMIT = 1       # Monday
    START_WDAY_UPPER_LIMIT = 5     # Friday
    TABLE_1_CAPACITY = 2
    TABLE_2_CAPACITY = 4
    
    protected
    
    def num_guests_less_than_4
      if (!(1..NUM_GUESTS_UPPER_LIMIT).include?(num_guests) )
          errors[:base] << "We can only accomadate a maximum of 4 guests"
          errors.add( :start_time, "Please select the number of guests again")
      end
    end
    
    def start_time_in_restaurant_hours
       if (!(START_TIME_LOW_LIMIT..START_TIME_UPPER_LIMIT).include?(start_time.hour) or !(START_WDAY_LOW_LIMIT..START_WDAY_UPPER_LIMIT).include?(start_time.wday))
         errors[:base] << "Please select a time between 5PM & 8PM - Monday to Friday"
         errors.add( :start_time, "The restaurant does not operate at the selected time")
       end
    end
    
    def table_capacity(table_num)
        case table_num.to_i
        when 1
            return TABLE_1_CAPACITY
        when 2
            return TABLE_2_CAPACITY
        end
    end
    
    def current_reservations
        @exis_res = Reservation.where(:start_time => (self.start_time - 59.minutes)...(self.start_time + 2.hours))
    end
    
    def available_tables
       tables = [1,2]
       current_reservations.each do |er|
           if(er.table_reserved.to_i == 1)
               tables.delete(1)
           elsif(er.table_reserved.to_i == 2)
               tables.delete(2)
           end
           break if tables.empty?
       end
       tables
    end
    
    def reserve_table
        avail_tables = available_tables
        case avail_tables.length.to_i
        when 0
            throw_table_unavailable_error
        when 1
            if table_capacity(avail_tables[0].to_i) >= self.num_guests.to_i
                self.table_reserved = avail_tables[0].to_i
            else
                throw_table_unavailable_error
            end
        when 2
            if table_capacity(avail_tables[0].to_i) >= self.num_guests.to_i
                self.table_reserved = avail_tables[0]
            elsif table_capacity(avail_tables[1].to_i) >= self.num_guests.to_i
                self.table_reserved = avail_tables[1]
            else
                throw_table_unavailable_error
            end
        end
    end
    
    def throw_table_unavailable_error
        errors[:base] << "This reservation cannot be made because.."
        errors.add( :table_reserved, "No table is available at the requested start time") 
    end
    
end
