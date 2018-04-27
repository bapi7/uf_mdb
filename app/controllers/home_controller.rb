class HomeController < ApplicationController
  before_action :latest_movies, only: [:index]

  def index

  end

  def login
  end

  def latest_movies
    sql = "select movie_id,primary_title, genres, poster from movies natural join ratings where start_year = to_char(sysdate, 'YYYY') and votes>2000 order by rating desc"
    @lmov = ActiveRecord::Base.connection.exec_query(sql).to_a.take(20)
  end

end
