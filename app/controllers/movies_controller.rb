class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      if params.key?(:sort)
        session[:sort] = params[:sort]
      elsif session.key?(:sort)
        params[:sort] = session[:sort]
        redirect_to movies_path(params) and return
      end
      @hilite = sort = params[:sort]
      @all_ratings = Movie.ratings
      if params.key?(:ratings)
        session[:ratings] = params[:ratings]
      elsif session.key?(:ratings)
        params[:ratings] = session[:ratings]
        redirect_to movies_path(params) and return
      end
      @checked_ratings = (params[:ratings].keys if params.key?(:ratings)) || @all_ratings
      @movies = Movie.order(sort).where(rating: @checked_ratings)
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end