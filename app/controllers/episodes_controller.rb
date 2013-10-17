class EpisodesController < ApplicationController
  load_and_authorize_resource :find_by => :param

  def index
    @tag = Tag.find(params[:tag_id]) if params[:tag_id]
    if params[:search].blank?
      @episodes = (@tag ? @tag.episodes : Episode).accessible_by(current_ability).recent
    else
      @episodes = Episode.search_published(params[:search], params[:tag_id])
    end

    render json: @episodes
  end

  def show
    #if params[:id] != @episode.to_param
    #  headers["Status"] = "301 Moved Permanently"
    #  redirect_to episode_url(@episode)
    #else
    #  @comment = Comment.new(:episode => @episode, :user => current_user)
    render json: @episode, serializer: EpisodeDetailedSerializer
    #end
  end

  def new
    @episode.position = Episode.maximum(:position).to_i + 1
  end

  def create
    @episode.load_file_sizes
    if @episode.save
      redirect_to @episode, :notice => "Successfully created episode."
    else
      render :new
    end
  end

  def edit
  end

  def update
    @episode.load_file_sizes
    if @episode.update_attributes(params[:episode])
      redirect_to @episode, :notice => "Successfully updated episode."
    else
      render :edit
    end
  end

  private

  def episodes_per_page
    case params[:view]
    when "list" then 40
    when "grid" then 24
    else 10
    end
  end
  
  def episode_params
    params.require(:episode).permit(:asciicasts, :description, 
                                    :name,  :notes, :position, :published_at, :duration, :tag_names, :timecode)
  end
end
