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
    @movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R']

    if params[:sort].nil? && params[:ratings].nil? && session[:sort].nil? && session[:ratings].nil?
      return @movies
    end

    if params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
    @ratings_selected = params[:ratings]
    if !@ratings_selected.nil?
      session[:ratings] = @ratings_selected
      @movies = @movies.where(rating: @ratings_selected.keys)

    elsif !session[:ratings].nil?
      @movies = @movies.where(rating: session[:ratings].keys)
    end

    
    @sort = params[:sort]
    if !@sort.nil?
      session[:sort] = @sort
      if @sort == "title"
        @movies = @movies.order("title ASC")
  
      elsif @sort == "release_date"
        @movies = @movies.order("release_date ASC")
      end

    elsif !session[:sort].nil?
      @temp = session[:sort]
      @movies = @movies.order("#{@temp} ASC")
    end

    # IF sort and ratings are both empty in params, then need to use sessions




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
