class CustomMarkdownRenderer < Redcarpet::Render::HTML
  def autolink(link, link_type)
    case link_type
      when :url then url_link(link)
      when :email then email_link(link)
    end
  end

  def url_link(url)
    if is_youtube_video_url?(url)
      embed_youtube_video(url)
    else
      normal_link(url)
    end
  end

  def is_youtube_video_url?(url)
    url =~ /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/i
  end

  def embed_youtube_video(url)
    uri = URI.parse(url)
    params = uri.query.split('&').map { |str| str.split('=') }.to_h
    video_id = params['v'] || uri.path[1..-1]
    %Q(<iframe width="560" height="315" src="//www.youtube.com/embed/#{video_id}?rel=0" frameborder="0" allowfullscreen></iframe>)
  end

  def normal_link(url)
    %Q(<a href="#{url}">#{url}</a>)
  end

  def email_link(email)
    %Q(<a href="mailto:#{email}">#{email}</a>)
  end
end
