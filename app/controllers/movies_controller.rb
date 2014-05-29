class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    sort = params[:sort] || session[:sort]

    @all_ratings = Movie.all_ratings
    
    @selected_ratings = params[:ratings].nil? ? Movie.all_ratings : params[:ratings].keys
    
    if params[:sort] != session[:sort] 
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort and return
    end

    if sort == "title"
      @movies = Movie.order(:title).where(rating: @selected_ratings).all
      @highlight = "title"
    elsif sort == "date"
      @movies = Movie.order(:release_date).where(rating: @selected_ratings).all
      @highlight = "date"
    else
      @movies = Movie.where(rating: @selected_ratings).all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
