class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_movie

    @cylinderChart = Fusioncharts::Chart.new({
                                                 :height => 200,
                                                 :width => 100,
                                                 :type => 'cylinderChart',
                                                 :renderAt => 'chart-container1',
                                                 :dataSource => {
                                                   :value => 44
                                                 }
                                             });

    @angularChart = Fusioncharts::Chart.new({
                                                :height => 200,
                                                :width => 300,
                                                :type => 'AngularGauge',
                                                :renderAt => 'chart-container',
                                                :dataSource => {
                                                    :value => 92
                                                }
                                            });

    sql = "select * from movies where movie_id = '" << params[:id].to_s << "'"
    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

    @movie = Movie.find(params[:id])
    @rating = Rating.find(params[:id])

    sql = "select * from celebrities natural join (select * from principal_cast where MOVIE_ID='" << params[:id] << "')"

    @pc = ActiveRecord::Base.connection.exec_query(sql).to_a

    genres = @movie.genres.split(',')

    genstr = ""
    genres.each do |gen|
      genstr << " like '%"<< gen << " %'" << gen
    end

    lrat = @rating.rating-1
    hrat = @rating.rating+1
    sql = "select movie_id,primary_title, poster from movies natural join ratings where genres like '%" << @movie.genres.to_s << "%' and rating between '" << lrat.to_s << "' and '" << hrat.to_s << "' and movie_id<>'" << @movie.movie_id << "' order by rating desc"



    @related = ActiveRecord::Base.connection.exec_query(sql).to_a.take(4)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def movie_params
    params.require(:movie).permit(:primary_title, :original_title, :start_year, :run_time_minutes, :genres)
  end

end
