class ActionController::Parameters
  def presence_all
    array = []
    self.each { |k, v| array << [k, v.presence] }
    hash = array.to_h
    ActionController::Parameters.new(hash) if self.is_a?(ActionController::Parameters)
  end
end
