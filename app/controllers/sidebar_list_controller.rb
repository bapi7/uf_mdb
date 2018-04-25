class SidebarListController < ApplicationController
 before_action :set_movie, only: [:displaySidebarList]
 before_action :display_movie_count_by_year, only: :index
  
  def displaySidebarList
  end

  def index
       @chart = Fusioncharts::Chart.new({
  :height => 400,
  :width => 600,
  :id => 'chart',
  :type => 'column2d',
  :renderAt => 'chart-container',
  :dataSource => {
    :chart => {
      :caption => 'Movie count by year',
      :subCaption => 'UFMDb',
      :xAxisname => 'Year',
      :yAxisName => 'Movie Count',
      :theme => 'ocean'
    },
    :data => @mov
  }
})
  end

  def set_movie
      sql = "select primary_title,genres,start_year, poster from movies where ROWNUM <= 3"
      @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

      #@movie = Movie.find(params[:id])
      #@rating = Rating.find(params[:id])
    end

  def display_movie_count_by_year
  	sql = "select start_year as label, count(*) as value from movies where start_year > 2000 group by start_year order by start_year"
    @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
    @mov = []
    @year_count.each do |yc|
    	yc["label"] = yc["label"].to_s
    	yc["value"] = yc["value"].to_s
    	@mov << yc
    end
  end
end
