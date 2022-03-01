class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      #checkboxes rating
      @all_ratings = Movie.all_ratings

      flash.keep
      if params[:ratings].present? && params[:sort].present?
        @movies =  ( sort_by params[:sort] ).where( params[:ratings]&.keys )
      elsif params[:ratings].present? || params[:sort].present?
        @movies = params[:ratings].nil? ? ( sort_by params[:sort] ) : (Movie.with_ratings params[:ratings]&.keys) 
      elsif session[:sort] && session[:ratings]
        #flash.keep
        redirect_to movies_path sort: session[:sort], ratings: session[:ratings]
      elsif params[:sort].nil? && session[:sort]
        #flash.keep
        redirect_to movies_path sort: session[:sort] 
      elsif params[:ratings].nil? && session[:ratings]
        #flash.keep
        redirect_to movies_path ratings: session[:ratings]
      end  

      @movies = params[:ratings].nil? ? ( sort_by params[:sort] ) : (Movie.with_ratings params[:ratings]&.keys) 


      if params[:ratings].present?
        session[:ratings] = params[:ratings]
      elsif params[:sort].present?
        session[:sort] = params[:sort]
      end

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