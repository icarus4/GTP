class Hash
  def presence_all
    hash = self.map { |k, v| [k, v.presence] }.to_h
    ActionController::Parameters.new(hash) if self.is_a?(ActionController::Parameters)
  end
end
