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
    # @movies = Movie.all()
    column = params[:sort]
    if column != nil
      session[:title_header] = column == "title" ? "hilite" : nil
      session[:release_header] = column == "release_date" ? "hilite" : nil
      @movies = Movie.order(column)
    end 
    
    if params[:ratings] != nil
      @filter_ratings = params[:ratings].keys
      session[:filter_ratings]= @filter_ratings
      @movies = Movie.with_ratings(@filter_ratings)
    elsif session[:filter_ratings] != nil
      @movies = Movie.with_ratings(session[:filter_ratings])
    else
      @movies = Movie.all
    end
    @all_ratings = Movie.all_ratings
    
    if session[:title_header] == "hilite"
      @movies = @movies.order(:title)
    elsif session[:release_header] == "hilite"
      @movies = @movies.order(:release_date)
    elsif session[:filter_ratings]== @filter_ratings
      @movies = Movie.with_ratings(@filter_ratings)
    end
    
    
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
