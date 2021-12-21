class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# Right now, the database_handle is a part of the classes interface, and
# therefore publicly available. It might make more sense to change attr_accessor
# to attr_reader, and make it private.
#
# Actual LS answer, is to delete the attr_accessor call all together, as it is
# almost certainly just an implementation detail, and as it stands now is
# providing easy access to the @database_handle instance variable.
