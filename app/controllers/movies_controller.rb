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
    @sortvar = params[:sort_by]
    @movies = Movie.all.order(@sortvar)
    @checkboxer = params[:ratings] || {'G' => 1, 'PG' => 1, 'PG-13' => 1, 'R' => 1, 'NC-17' => 1}
    
    if @checkboxer.nil?
      @movies = Movie.where(:rating => @checkboxer.keys).all
    else
      if @sortvar.nil?
          @movies = Movie.where(:rating => @checkboxer.keys).all
      else
          @movies = Movie.where(:rating => @checkboxer.keys).order(@sortvar).all
      end
    end
    
    if @sortvar == 'title'
      @insttitl = 'highlight'
    elsif @sortvar == 'release_date'
      @instreldate ='highlight'
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

  def updtmovie
  end
  
  def updtmoviesomething
    @movie = Movie.find_by_title(params[:movie][:oldTitle])
    if (@movie.nil?)
      flash[:notice] = "error!"
    else
      if (not (params[:movie][:title] == "" ||  params[:movie][:rating] == '--'))
        @movie.update_attributes!(params.require(:movie).permit(:title))
        @movie.update_attributes!(params.require(:movie).permit(:release_date))
        @movie.update_attributes!(params.require(:movie).permit(:rating))
        flash[:notice] = "Updated!"
      else
        flash[:notice] = "Atleast one field is empty!"
      end
      # if (not params[:movie][:release_date].nil?)
      #   @movie.update_attributes!(params.require(:movie).permit(:release_date))
      # end
      # if (params[:movie][:rating] != '--')
      #   @movie.update_attributes!(params.require(:movie).permit(:rating))
      # end
      
    end
    redirect_to movies_path
  end
  
  def delmov
  end
  
  def delmovsomething
    @moviename = Movie.find_by_title(params[:movie][:title])
    @movierate = Movie.find_by_rating(params[:movie][:rating])
    
    if (@moviename.nil? && @movierate.nil?)
      flash[:notice] = "No movie selected!!"
    else
      if (not @moviename.nil?)
        @moviename.destroy
      end
      while not (@movierate.nil?)
        @movierate.destroy
        @movierate = Movie.find_by_rating(params[:movie][:rating])
      end
    end
    redirect_to movies_path
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
