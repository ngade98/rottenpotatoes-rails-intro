class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Part 1 with sessions
    if params.key?(:sort_by)
      session[:sort_by] = params[:sort_by]
    end
    if session.key?(:sort_by)
      params[:sort_by] = session[:sort_by]
      redirect_to movies_path(params) 
      return 
    end
    @hilite = sort_by = session[:sort_by]
    
    #Part 2 with sessions
    @all_ratings = Movie.all_ratings
    if params.key?(:ratings)
      session[:ratings] = params[:ratings]
    end
    if session.key?(:ratings)
      params[:ratings] = session[:ratings]
      redirect_to movies_path(params) 
      return 
    end
    
    @comp_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings
    @movies = Movie.order(sort_by).where(rating: @comp_ratings)
    
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
