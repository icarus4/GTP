module ApplicationHelper
  def render_status(status)
    case status
    when 'draft'
      '草稿'
    when 'active'
      '已成立'
    when 'received'
      '已收貨'
    end
  end
end
