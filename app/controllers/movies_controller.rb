class MoviesController < ApplicationController
  
  def index
    # binding.pry
    @options = [["",""], ["Under 90 minutes", 0], ["Between 90 and 120 minutes", 1], ["Over 120 minutes", 2]]
    # @movies = Movie.all
    @movies = Movie.search_by_title(params[:title])
    @movies = @movies.search_by_director(params[:director])
    case params[:runtime_in_minutes]
    when "0"
      @movies = @movies.less_than_90
    when "1"
      @movies = @movies.between_90_and_120_minutes
    when "2"
      @movies = @movies.greater_than_120_minutes
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
  @movie = Movie.find(params[:id])
  @movie.destroy
  redirect_to movies_path
  end


  protected

  def movie_params
    params.require(:movie).permit(
      :title, :director, :runtime_in_minutes, :description, :poster_image_url, :release_date, :image, :remote_image_url
    )
  end 
end
