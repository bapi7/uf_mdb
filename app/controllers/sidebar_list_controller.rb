class SidebarListController < ApplicationController
 before_action :set_movie, only: [:displaySidebarList]
  
  def displaySidebarList
  end

  def set_movie
      sql = "select primary_title,genres,start_year, poster from movies where ROWNUM <= 3"
      @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

      #@movie = Movie.find(params[:id])
      #@rating = Rating.find(params[:id])
    end
end
