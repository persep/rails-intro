class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    # params is a HASH
    sort = params[:sort] || session[:sort]  

    @all_ratings = Movie.all_ratings
    
    #@selected_ratings = params[:ratings].nil? ? Movie.all_ratings : params[:ratings].keys

    #debugger
    if params[:ratings].nil? and session[:ratings].nil?
      @selected_ratings = Movie.all_ratings
    else
      if !params[:ratings].nil? and params[:ratings].class == Array
        param = params[:ratings]
      elsif !params[:ratings].nil?
        param = params[:ratings].keys
      end
      @selected_ratings = params[:ratings].nil? ? session[:ratings] : param
    end


    #debugger
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      # in redirect_to even if we pass an array as an option when the url is redirecte
      # it will in params as a hash
      redirect_to :sort => sort, :ratings => @selected_ratings and return
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
