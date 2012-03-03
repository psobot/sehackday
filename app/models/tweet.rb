class Tweet < ActiveRecord::Base

  validates_uniqueness_of :tweet_id

  def self.unprocessed
    self.where :processed => false
  end

  MUST_CONTAIN = "sehackday"
  NEW_PROJECT = %w{ hack project demo prototype is }
  PHOTO_PROVIDERS = %w{ http://twitpic instagram }

  def self.parse tweet
    # Potential tweet format:
    #   [My|Our] #sehackday #[hack|project|demo]: #<hackname> <some short description of the hack>.
    #   (#with @<collaborator>)? (http://pic.twitter.com/something)? (http://github.com/psobot/blah)?

    #-tweet['entities']['hashtags'] is an array of the hashtags and their indices
    # tweet['entities']['urls'] is a list of URLs
    # tweet['text'] is the actual body text
    # tweet['place']['bounding_box'] is the geo bounding box
    #   tweet['place']['bounding_box']['type'] is Polygon or Point
    #   tweet['place']['bounding_box']['coordinates'] is an array of coords lng, lat (?)
    # tweet['id'] is an integer ID (long long)
    # tweet['user']['id'] is the user's id
    # tweet['user']['screen_name']
    # Time.parse(tweet['created_at']) is the publish time
    
    raise "Tweet does not contain ##{MUST_CONTAIN}."\
      if not tweet['entities']['hashtags'].any? { |hashtag| hashtag['text'].downcase == MUST_CONTAIN }


    logger.debug "Checking new project tweets"
    # Check for "new project" tweets
    if tweet['entities']['hashtags'].any? { |hashtag| NEW_PROJECT.include? hashtag['text'].downcase }
      # Must be of the form:
      #   <text> #hashtags <#projectname> <project description> http://links/

      time_posted = Time.parse(tweet['created_at'])

      last_hashtag = tweet['entities']['hashtags'].max_by { |hashtag|
        if NEW_PROJECT.include? hashtag['text'].downcase
          hashtag['indices'][1]
        else
          0
        end
      }
      first_url = tweet['entities']['urls'].min_by { |url| url['indices'][0] }
      project_matches = \
        tweet['text'][last_hashtag['indices'][1]+1...(first_url ? first_url['indices'][0] : tweet['text'].length)]\
        .strip.match(/(.+?)[ ]?[,-:!.;][ ]?(.+)?/)
      project_name = project_matches[1]
      project_description = project_matches[2]
      
      project_links = tweet['entities']['urls'].collect { |url|
        PHOTO_PROVIDERS.any? {
          |provider| url['expanded_url'].include? provider
        } ? nil : url['expanded_url']
      }.compact


      image_urls = if tweet['entities'].include? 'media'
        tweet['entities']['media'].collect do |media|
          if media['type'] == "photo"
            if media['sizes'].include? 'large'
              media['media_url'] + ":" + 'large'
            else
              media['media_url']
            end
          end
        end.compact
      else
        []
      end

      #TODO: get exact lat/lng values here
      lat = 0
      lng = 0

      # By now we have:
      #   tweet['user']['screen_name']
      #   project_name
      #   project_description
      #   project_links
      #   image_urls
      # ...which should be enough.
      
      logger.debug(image_urls.inspect)
      me = create(  :tweet_id => tweet['id'],
                    :username => tweet['user']['screen_name'],
                    :lat => lat,
                    :lng => lng,
                    :raw => tweet,
                    :processed => false )

      user = Participant.find_or_create_by_user_from_tweet(tweet['user'], me)
      project = Project.find_by_name_or_links(project_name, project_links)
      if not project
        project = Project.create(:name => project_name,
                                 :link => project_links.first,
                                 :description => project_description,
                                 :tweet_id => me.id)
      end
      if not image_urls.empty?
        begin
          project.images << Image.download(image_urls.first)
        rescue Exception => ex
          logger.error ex
        end
      end
      event = Event.at(time_posted)
      Contribution.create(:project_id => project.id,
                          :participant_id => user.id,
                          :event_id => event ? event.id : nil)
    end

  end



end
