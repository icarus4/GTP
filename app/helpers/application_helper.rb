module ApplicationHelper
  def render_status(status)
    case status
    when 'draft'
      '草稿'
    when 'active'
      '已成立'
    when 'received'
      '已收貨'
    when 'finalized'
      'Finalized'
    when 'fulfilled'
      '已送貨'
    when 'void'
      '作廢'
    when 'deleted'
      '已刪除'
    else
      raise ArgumentError, "Invalid status: #{status}"
    end
  end

  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? "active" : nil
  end
end
