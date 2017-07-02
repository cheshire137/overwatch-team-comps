class CustomMarkdownRenderer < Redcarpet::Render::HTML
  VIDEO_WIDTH = 560
  VIDEO_HEIGHT = 315

  def autolink(link, link_type)
    case link_type
      when :url then url_link(link)
      when :email then email_link(link)
    end
  end

  def url_link(url)
    if is_youtube_video_url?(url)
      embed_youtube_video(url)
    elsif is_twitch_clip_url?(url)
      embed_twitch_clip(url)
    else
      normal_link(url)
    end
  end

  def is_twitch_clip_url?(url)
    url =~ /^(?:https?:\/\/)?(?:www\.)?clips\.twitch\.tv/i
  end

  def is_youtube_video_url?(url)
    url =~ /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/i
  end

  def embed_youtube_video(url)
    uri = URI.parse(url)
    params = get_url_params(uri)
    video_id = params['v'] || uri.path[1..-1]
    %Q(<iframe width="#{VIDEO_WIDTH}" height="#{VIDEO_HEIGHT}" src="//www.youtube.com/embed/#{video_id}?rel=0" frameborder="0" allowfullscreen></iframe>)
  end

  def embed_twitch_clip(url)
    uri = URI.parse(url)
    params = get_url_params(uri)
    video_id = params['clip'] || uri.path[1..-1]
    %Q(<iframe src="https://clips.twitch.tv/embed?clip=#{video_id}&autoplay=false&tt_medium=clips_embed" width="#{VIDEO_WIDTH}" height="#{VIDEO_HEIGHT}" frameborder="0" scrolling="no" allowfullscreen="true"></iframe>)
  end

  def get_url_params(uri)
    query = uri.query
    return {} unless query

    query.split('&').map { |str| str.split('=') }.to_h
  end

  def normal_link(url)
    %Q(<a href="#{url}">#{url}</a>)
  end

  def email_link(email)
    %Q(<a href="mailto:#{email}">#{email}</a>)
  end
end
