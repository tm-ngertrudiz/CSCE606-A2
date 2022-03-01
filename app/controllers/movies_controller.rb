class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      #checkboxes rating
      @all_ratings = Movie.all_ratings
      
      #sort  
      #sort = params[:sort] || session[:sort]
      #ratings = params[:ratings]&.keys || session[:ratings]

      #if params[:sort].nil? && session[:sort]
      #  redirect_to movies_path(sort: session[:sort])
      #end
      
      #if !(params[:sort].present? && params[:ratings].present?)
        #redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
        #redirect_to movies_path(sort: session[:sort])
      #end

      sort = params[:sort]
      @movies = params[:ratings].nil? ? ( sort_by sort ) : (Movie.with_ratings params[:ratings]&.keys) 

      session['ratings'] = params[:ratings]
      session['sort'] = params[:sort]
    end

    def sort_by sort
      if sort == 'title'
        @header_title_highlight = 'bg-warning hilite'
        Movie.order('title asc')
      elsif sort == 'release_date'
        @header_release_highlight = 'bg-warning hilite'
        Movie.order('release_date asc')
      else
        Movie.all
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end