class ApplicationController < ActionController::Base

  def index
    if user_signed_in?
        @event = Event.most_recent
        @can_post = true
        @admin_post = true
    else
        @event = Event.at Time.now.utc
        @admin_post = false
        if @event.nil?
            @can_post = false
        else
            @ipblock = IPAddress @event.location.ip_block
            @can_post = @ipblock.include? IPAddress(request.remote_ip) 
        end
    end
    @project = Project.new if @can_post 
    render
  end

  def create
    # => I realize how un-idiomatic this Rails code is, but the event
    # => is tonight and I have other things to hack on. Just do it.

    if user_signed_in?
        @event = Event.most_recent
    else
        @event = Event.at Time.now.utc
        @ipblock = IPAddress @event.location.ip_block
        redirect_to :root if @event.nil?

        unless @ipblock.include? IPAddress(request.remote_ip) 
            flash[:error] = "Whoops! You have to be at the event to post!"
            redirect_to :root
        end
    end

    project = Project.new
    project.name = params[:project][:name]
    project.link = params[:project][:link]
    project.description = params[:project][:description]
    project.participants = params[:project][:participants].split(',').collect do |name|
        # Resolve each name or @symbol into a Participant, creating as necessary.

        name.strip!
        match = nil

        if name.start_with? "@"
            match = Participant.find_by_username name[1..-1]
            if match.nil?
                match = Participant.create :username => name[1..-1]
            end
        end

        if match.nil?
            match = Participant.find_by_full_name name
            if match.nil?
                if name.split(" ").length == 2
                    first, last = name.split(' ')
                    match = Participant.create :full_name => name, :first_name => first, :last_name => last
                    match.save!
                else
                    match = Participant.create :full_name => name
                    match.save!
                end
            end
        end

        match
    end

    unless params[:project][:photos].nil?
        project.images = [Image.create(:file => params[:project][:photos][:image])]
    end

    project.save!

    project.participants.each do |participant|
        participant.contributions << Contribution.new(
            project: project,
            event: @event
        )
    end

    redirect_to :root
  end

  def parse
    raise "Authentication key doesn't match!" if params[:key] != INCOMING_KEY
    Tweet.parse JSON.parse(params[:raw])
    render :json => {:status => 0, :message => "success"}
  end

end
