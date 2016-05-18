module ApplicationHelper
  
  # Tags for OpenGraph
  def og_tags
    {
      title: 'GSOH: Great Sense of Home',
      description: 'Helping you find that perfect place to live in Leeds',
      image: image_url('opo-square.jpg')
    }.tap do |tags|
      if params[:result]
        tags[:title] = "My perfect #Leeds home is in #{params[:result]}: #{params[:score].with_indefinite_article}% match! Where's yours?"
        tags[:description] = "GSOH: #{tags[:description]}"
      end
    end    
  end
  
  # Tags for Twitter
  def twitter_tags
    {
      card: 'summary',
      image: image_url('opo-square.jpg'),
      title: 'GSOH: Great Sense of Home',
      description: 'Helping you find that perfect place to live in Leeds',
      site: '@fishpercolator'
    }
  end
  
  def errors_for(obj)
    if obj.errors.any?
      render partial: 'application/errors_for', object: obj
    end
  end
  
  def feature_name_and_subtype(feature)
    if feature.subtype?
      "#{feature.name} (#{t feature.subtype})".html_safe
    else
      feature.name
    end
  end
  
end
