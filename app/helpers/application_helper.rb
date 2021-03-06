module ApplicationHelper
  def image_exists?(file_name)
    path = Rails.root.join('app', 'assets', 'images', file_name)
    FileTest.exist?(path)
  end

  def page_title(path)
    case path
    when '/', '/user' then 'Team Composition Form'
    when '/about', '/user/about' then 'About'
    when '/user/hero-pool' then 'Your Hero Pool'
    else
      if path.start_with?('/comp/')
        slug = path.split('/comp/').last
        composition = Composition.where(slug: slug).first
        if composition
          "#{composition.name} - #{composition.map.name}"
        end
      end
    end
  end
end
