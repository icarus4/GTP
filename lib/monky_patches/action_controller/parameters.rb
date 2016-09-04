class ActionController::Parameters
  def presence_all
    array = []
    self.each { |k, v| array << [k, v.presence] }
    hash = array.to_h
    ActionController::Parameters.new(hash)
  end
end
