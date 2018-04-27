require 'will_paginate/array'
class SidebarListController < ApplicationController
  #before_action :set_movie, only: [:top_movies]

  def displaySidebarList
  end

  def index
    sql = "select case
    when r.rating >= 0 and r.rating <1 then '0-1'
    when r.rating >= 1 and r.rating <2 then '1-2'
    when r.rating >= 2 and r.rating <3 then '2-3'
    when r.rating >= 3 and r.rating <4 then '3-4'
    when r.rating >= 4 and r.rating <5 then '4-5'
    when r.rating >= 5 and r.rating <6 then '5-6'
    when r.rating >= 6 and r.rating <7 then '6-7'
    when r.rating >= 7 and r.rating <8 then '7-8'
    when r.rating >= 8 and r.rating <9 then '8-9'
    when r.rating >= 9 and r.rating <10 then '9-10'
    end as rating_range, count(*) as val
from (select rating from movies m, ratings r Where m.movie_id = r.movie_id and r.rating >= 1 and m.start_year = '2018' order by r.rating DESC ) r
group by case
    when r.rating >= 0 and r.rating <1 then '0-1'
    when r.rating >= 1 and r.rating <2 then '1-2'
    when r.rating >= 2 and r.rating <3 then '2-3'
    when r.rating >= 3 and r.rating <4 then '3-4'
    when r.rating >= 4 and r.rating <5 then '4-5'
    when r.rating >= 5 and r.rating <6 then '5-6'
    when r.rating >= 6 and r.rating <7 then '6-7'
    when r.rating >= 7 and r.rating <8 then '7-8'
    when r.rating >= 8 and r.rating <9 then '8-9'
    when r.rating >= 9 and r.rating <10 then '9-10'
    end
    order by rating_range"
        @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
        mov = []
        @year_count.each do |yc|
            yc["label"] = yc["label"].to_s
            yc["value"] = yc["value"].to_s
            mov << yc
          end

        @chart = Fusioncharts::Chart.new({
                                             :height => 500,
                                             :width => 600,
                                             :id => 'chart',
                                             :type => 'pie3d',
                                             :renderAt => 'chart-container',
                                             :dataSource => {
                                                 :chart => {
                                                     :caption => 'Movie count by year',
                                                     :subCaption => 'UFMDb',
                                                     :startingAngle => "120",
                                                     :showLabels => "0",
                                                     :showLegend => "1",
                                                     :enableMultiSlicing => "0",
                                                     :slicingDistance => "15",
                                                     :showPercentValues => "1",
                                                     :showPercentInTooltip => "0",
                                                     :plotTooltext => "Rating range : $label Total Movie Count : $datavalue",
                                                     :theme => 'ocean'
                                                 },
                                                 :data => mov
                                             }
                                         })
  end

  def boxoffice_hits

    #year = params[:year]
    #rating = params[:rating]
    sort_by = params[:sort_by]

    sql = "select m.movie_id, poster,primary_title,bo
        from movies m,
                    (select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
    where m.movie_id = b.movie_id and b.bo > b1.avg1
    order by b.bo " + sort_by.to_s

    @movhit = ActiveRecord::Base.connection.exec_query(sql).to_a
    @hits = @movhit.paginate(:page=> params[:page], :per_page=>15)




    sql ="select m.START_YEAR as label, count(*) as value
     from movies m,
     (select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
     where m.movie_id = b.movie_id and b.bo > b1.avg1
group by m.START_YEAR order by m.START_YEAR " + sort_by.to_s
    @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a




    mov = []
    @year_count.each do |yc|
      yc["label"] = yc["label"].to_s
      mov << yc
    end
    mov.to_json


    mov1=[]
    @year_count.each do |yc|
      yc["value"] = yc["value"].to_s
      mov1 << yc
    end
    mov1.to_json

    @piechart = Fusioncharts::Chart.new({
                                            :height => 400,
                                            :width => 600,
                                            :type => 'mscombi2d',
                                            :renderAt => 'chart-container',
                                            :dataSource => {
                "chart" =>  {
                "caption": "Number of Hit movies by Year",
                "xaxisname": "Year",
                "yaxisname": "Number of Hit Movies",
                "theme": "ocean"
            },
                "categories": [
                    {
                        :category => mov
                    }
                ],
            "dataset": [
                {
                    "seriesname": "Number of Hit Movies",
                    "renderas": "line",
                    "showvalues": "0",
                    :data => mov1
                },
                {
                    "seriesname": "Number of Hit Movies",
                    "renderas": "area",
                    "showvalues": "0",
                    :data => mov1
                }

              ]
            }
                                        });

  end

  def top_movies

    year = params[:year]
    rating = params[:rating]
    sort_by = params[:sort_by]

    sql = "Select m.movie_id, poster, primary_title, start_year, rating From movies m, ratings r Where m.movie_id = r.movie_id and r.rating >= " + rating.to_s + " and m.start_year = " + year.to_s + " order by r.rating " + sort_by.to_s
    @marr = ActiveRecord::Base.connection.exec_query(sql).to_a
    @movie = @marr.paginate(:page=> params[:page], :per_page=>15)

    sql = "select case
    when r.rating >= 0 and r.rating <1 then '0-1'
    when r.rating >= 1 and r.rating <2 then '1-2'
    when r.rating >= 2 and r.rating <3 then '2-3'
    when r.rating >= 3 and r.rating <4 then '3-4'
    when r.rating >= 4 and r.rating <5 then '4-5'
    when r.rating >= 5 and r.rating <6 then '5-6'
    when r.rating >= 6 and r.rating <7 then '6-7'
    when r.rating >= 7 and r.rating <8 then '7-8'
    when r.rating >= 8 and r.rating <9 then '8-9'
    when r.rating >= 9 and r.rating <10 then '9-10'
    end as label, count(*) as value
from (select rating from movies m, ratings r Where m.movie_id = r.movie_id and r.rating >= " + rating.to_s + " and m.start_year = " + year.to_s + " order by r.rating " + sort_by.to_s+" ) r
    group by case
             when r.rating >= 0 and r.rating <1 then '0-1'
             when r.rating >= 1 and r.rating <2 then '1-2'
             when r.rating >= 2 and r.rating <3 then '2-3'
             when r.rating >= 3 and r.rating <4 then '3-4'
             when r.rating >= 4 and r.rating <5 then '4-5'
             when r.rating >= 5 and r.rating <6 then '5-6'
             when r.rating >= 6 and r.rating <7 then '6-7'
             when r.rating >= 7 and r.rating <8 then '7-8'
             when r.rating >= 8 and r.rating <9 then '8-9'
             when r.rating >= 9 and r.rating <10 then '9-10'
             end
    order by label"
    @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
    mov = []
    @year_count.each do |yc|
      yc["label"] = yc["label"].to_s
      yc["value"] = yc["value"].to_s
      mov << yc
    end

    @piechart = Fusioncharts::Chart.new({
                                            :height => 500,
                                            :width => 600,
                                            :id => 'chart',
                                            :type => 'pie3d',
                                            :renderAt => 'chart-container',
                                            :dataSource => {
                                                :chart => {
                                                    :caption => 'Movie count by year',
                                                    :subCaption => 'UFMDb',
                                                    :startingAngle => "120",
                                                    :showLabels => "0",
                                                    :showLegend => "1",
                                                    :enableMultiSlicing => "0",
                                                    :slicingDistance => "15",
                                                    :showPercentValues => "1",
                                                    :showPercentInTooltip => "0",
                                                    :plotTooltext => "Rating range : $label Total Movie Count : $datavalue",
                                                    :theme => 'ocean'
                                                },
                                                :data => mov
                                            }
                                        })

  end


  def celeb_hits

    nom = params[:nom]
    ave = params[:ave]
    sort_by = params[:sort_by]
    sql = "select celebrity_name, l.noofmovies as movie_count , k.hits as hits, avg_rating
from
(select p.celebrity_id,count(*) as hits
from movies m, principal_cast p,
(select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
where m.movie_id = b.movie_id and b.bo > b1.avg1 and p.movie_id = m.movie_id
group by p.celebrity_id) k,
(select c.CELEBRITY_ID,c.CELEBRITY_NAME,count(r.rating)as NoOfmovies, avg(r.rating) as Avg_rating
from movies m, principal_cast p, ratings r, celebrities c
where m.movie_id = p.movie_id and m.movie_id = r.movie_id and p.CELEBRITY_ID = c.CELEBRITY_ID
group by c.celebrity_name,c.CELEBRITY_ID) l
where k.celebrity_id = l.celebrity_id and l.NoOfmovies > "+nom+" and avg_rating >"+ ave +" order by k.hits " + sort_by.to_s
   @movi = ActiveRecord::Base.connection.exec_query(sql).to_a


    chart_data = Array.new


    test =[]
    @movi.each do |data|
      obj = {}
      obj["label"] = data["celebrity_name"]
      test << obj
    end
      test.to_json

    test1 =[]
    @movi.each do |data|
      obj1 ={}
      obj1["value"] = data["movie_count"].to_s
      test1 << obj1
    end
    test1.to_json

    test2 =[]
    @movi.each do |data|
      obj2 ={}
      obj2["value"] = data["hits"].to_s
      test2 << obj2
    end
    test2.to_json

    @piechart = Fusioncharts::Chart.new({
                                            :height => 400,
                                            :width => 600,
                                            :type => 'mscombi2d',
                                            :renderAt => 'chart-container',
                                            :dataSource => {
                                                "chart" =>  {
                                                    "caption": "Celebrity Hits and Movie Count",
                                                    "subcaption": "Last year",
                                                    "xaxisname": "Movies Count",
                                                    "yaxisname": "Celebrity Name",
                                                    "theme": "ocean"
                                                },
                                                "categories": [
                                                    {
                                                        :category => test
                                                    }
                                                ],
                                                "dataset": [
                                                    {
                                                        "seriesname": "Movie Count",
                                                        "renderas": "line",
                                                        "showvalues": "0",
                                                        :data => test1
                                                    },
                                                    {
                                                        "seriesname": "Hit Movies",
                                                        "renderas": "area",
                                                        "showvalues": "0",
                                                        :data => test2
                                                    }

                                                ]
                                            }
                                        });

    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)

  end

 def celebrity_prime_comp

    nom = params[:nom]
    
    sql = " select t1.celebrity_name
from
(select k.celebrity_id,celebrity_name, l.noofmovies,k.hits,l.birth_year, l.DEATH_YEAR, (l.birth_year+20) as start_year1, (l.birth_year+50) as end_year1
from
(select p.celebrity_id,count(*) as hits
from movies m, principal_cast p,
(select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
where m.movie_id = b.movie_id and b.bo > b1.avg1 and p.movie_id = m.movie_id
group by p.celebrity_id) k,
(select c.CELEBRITY_ID,c.CELEBRITY_NAME,count(r.rating)as NoOfmovies, avg(r.rating) as Avg_rating,c.birth_year, c.DEATH_YEAR
from movies m, principal_cast p, ratings r, celebrities c
where m.movie_id = p.movie_id and m.movie_id = r.movie_id and p.CELEBRITY_ID = c.CELEBRITY_ID and c.birth_year !='\\N'
group by c.celebrity_name,c.CELEBRITY_ID, c.birth_year, c.DEATH_YEAR) l
where k.celebrity_id = l.celebrity_id) t1
where t1.start_year1 >= (select (birth_year+20)
from celebrities where celebrities.CELEBRITY_NAME= '"+ nom+"') and t1.end_year1 <= (select (birth_year+50) 
from celebrities where celebrities.CELEBRITY_NAME= '"+ nom+"') and t1.celebrity_name != '"+ nom+"' "
    @movi = ActiveRecord::Base.connection.exec_query(sql).to_a

    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)

  end

  def barchart
    @barchart = Fusioncharts::Chart.new({
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
                                                :data => mov
                                            }
                                        })
  end

 def piechart

   sql = "select case when r.rating >= 0 and r.rating <1 then '0-1' when r.rating >= 1 and r.rating <2 then '1-2' when r.rating >= 2 and r.rating <3 then '2-3' when r.rating >= 3 and r.rating <4 then '3-4' when r.rating >= 4 and r.rating <5 then '4-5' when r.rating >= 5 and r.rating <6 then '5-6' when r.rating >= 6 and r.rating <7 then '6-7' when r.rating >= 7 and r.rating <8 then '7-8' when r.rating >= 8 and r.rating <9 then '8-9' when r.rating >= 9 and r.rating <10 then '9-10' end as label, count(*) as value from (select * from ratings order by rating asc) r group by case when r.rating >= 0 and r.rating <1 then '0-1' when r.rating >= 1 and r.rating <2 then '1-2' when r.rating >= 2 and r.rating <3 then '2-3' when r.rating >= 3 and r.rating <4 then '3-4' when r.rating >= 4 and r.rating <5 then '4-5' when r.rating >= 5 and r.rating <6 then '5-6' when r.rating >= 6 and r.rating <7 then '6-7' when r.rating >= 7 and r.rating <8 then '7-8' when r.rating >= 8 and r.rating <9 then '8-9' when r.rating >= 9 and r.rating <10 then '9-10' end order by label"

   @year_rating = ActiveRecord::Base.connection.exec_query(sql).to_a
   @list = []
   @year_rating.each do |yc|
     yc["label"] = yc["label"].to_s
     yc["value"] = yc["value"].to_s
     @list << yc
   end

   @piechart = Fusioncharts::Chart.new({
                                           :height => 500,
                                           :width => 600,
                                           :id => 'chart',
                                           :type => 'pie3d',
                                           :renderAt => 'chart-container',
                                           :dataSource => {
                                               :chart => {
                                                   :caption => 'Movie count by year',
                                                   :subCaption => 'UFMDb',
                                                   :startingAngle => "120",
                                                   :showLabels => "0",
                                                   :showLegend => "1",
                                                   :enableMultiSlicing => "0",
                                                   :slicingDistance => "15",
                                                   :showPercentValues => "1",
                                                   :showPercentInTooltip => "0",
                                                   :plotTooltext => "Rating range : $label Total Movie Count : $datavalue",
                                                   :theme => 'ocean'
                                               },
                                               :data => @list
                                           }
                                       });

 end

  def celeb_rating

    
    rating = params[:rating]
    sort_by = params[:sort_by]

    sql = "select t1.celebrity_name, count(*) as movie_count, avg(r1.rating) as celeb_rating
    from
    (select c.CELEBRITY_ID,c.CELEBRITY_NAME,count(r.rating)as NoOfmovies, avg(r.rating) as Avg_rating
    from movies m, principal_cast p, ratings r, celebrities c
    where m.movie_id = p.movie_id and m.movie_id = r.movie_id and p.CELEBRITY_ID = c.CELEBRITY_ID  
    group by c.celebrity_name,c.CELEBRITY_ID) t1, principal_cast p1, movies m1, ratings r1
    where t1.celebrity_id = p1.celebrity_id and p1.movie_id = m1.movie_id and m1.movie_id = r1.movie_id and t1.avg_rating >= "+rating.to_s+"
    GROUP BY t1.celebrity_name
 order by count(*) " + sort_by.to_s
    @movi = ActiveRecord::Base.connection.exec_query(sql).to_a

    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)
  end

  def celeb_rating_genre

    
    rating = params[:rating]
    sort_by = params[:sort_by]

      sql = "select t1.celebrity_name,m1.genres, count(*) as movie_count, avg(r1.rating) as average_rating
    from
(select c.CELEBRITY_ID,c.CELEBRITY_NAME,count(r.rating)as NoOfmovies, avg(r.rating) as Avg_rating
from movies m, principal_cast p, ratings r, celebrities c
where m.movie_id = p.movie_id and m.movie_id = r.movie_id and p.CELEBRITY_ID = c.CELEBRITY_ID  
group by c.celebrity_name,c.CELEBRITY_ID) t1, principal_cast p1, movies m1, ratings r1
where t1.celebrity_id = p1.celebrity_id and p1.movie_id = m1.movie_id and m1.movie_id = r1.movie_id and r1.rating >= "+rating.to_s+"
GROUP BY t1.celebrity_name, m1.genres
order by count(*) " + sort_by.to_s


    @movi = ActiveRecord::Base.connection.exec_query(sql).to_a

    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)

  end

   def pop_production_votes

    votes = params[:votes]
    rating = params[:rating]
    sort_by = params[:sort_by]



    sql ="select b.production, sum(r.VOTES) as sum_votes
      from
      movies m, boxoffice b, ratings r
      where m.movie_id = b.movie_id and m.movie_id = r.movie_id and r.rating > "+rating +" and r.VOTES >= "+ votes+"
      group by b.production "

    @movi = ActiveRecord::Base.connection.exec_query(sql).to_a

    test =[]
    @movi.each do |data|
      obj = {}
      obj["label"] = data["production"]
      obj["value"] = data["sum_votes"]
      test << obj
    end
    test.to_json


    @barchart = Fusioncharts::Chart.new({
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
                                                :data => test
                                            }
                                        })




    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)

  end

def pop_production_critic

    
    rating = params[:rating]
    sort_by = params[:sort_by]

      sql = "select b.production, avg(r.rating) as rating1
from
movies m, boxoffice b, ratings r
where m.movie_id = b.movie_id and m.movie_id = r.movie_id
group by b.production
order by avg(r.rating) " + sort_by.to_s


    @movi = ActiveRecord::Base.connection.exec_query(sql).to_a

    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)
  end

  def actor_age_hits

    
    rating = params[:rating]
    sort_by = params[:sort_by]

      sql = "select t1.celebrity_name, t1.noofmovies,t1.hits,t2.age
  from
  (select l.celebrity_id,celebrity_name, l.noofmovies,k.hits, avg_rating
  from
  (select p.celebrity_id,count(*) as hits
  from movies m, principal_cast p,
  (select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
  where m.movie_id = b.movie_id and b.bo > b1.avg1 and p.movie_id = m.movie_id
  group by p.celebrity_id) k,
  (select c.CELEBRITY_ID,c.CELEBRITY_NAME,count(r.rating)as NoOfmovies, avg(r.rating) as Avg_rating
  from movies m, principal_cast p, ratings r, celebrities c
  where m.movie_id = p.movie_id and m.movie_id = r.movie_id and p.CELEBRITY_ID = c.CELEBRITY_ID  
  group by c.celebrity_name,c.CELEBRITY_ID) l
  where k.celebrity_id = l.celebrity_id) t1,
  (select  t.celebrity_id, t.CELEBRITY_NAME,t.age
from
(select case
when death_year ='\\N' and birth_year = '\\N' then 0
when death_year ='\\N'  then 2018-birth_year
when birth_year = '\\N' then 55
when death_year !='\\N' and birth_year != '\\N' then(death_year - birth_year) 
end as age, c.CELEBRITY_NAME,c.BIRTH_YEAR,c.DEATH_YEAR, c.CELEBRITY_ID
from celebrities c ) t) t2
where t1.celebrity_id = t2.celebrity_id and t2.age > 0 and rownum <=1000
order by age  " + sort_by.to_s


    @movi = ActiveRecord::Base.connection.exec_query(sql).to_a

    @movie = @movi.paginate(:page=> params[:page], :per_page=>15)
  end

  def table_count


      sql = "select  table_name, 
   num_rows counter  from USER_TABLES  
   where num_rows > 1 order by 
   counter desc " 


    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

   
    render :table_count
  end

  def movie_table
      sql = "select mpaa_rating as label, count(*) as value 
from movies
group by mpaa_rating "
      @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
      mov = []
      @year_count.each do |yc|
        yc["label"] = yc["label"].to_s
        yc["value"] = yc["value"].to_s
        mov << yc
      end

    @piechart = Fusioncharts::Chart.new({
                                            :height => 500,
                                            :width => 600,
                                            :id => 'chart',
                                            :type => 'pie3d',
                                            :renderAt => 'chart-container',
                                            :dataSource => {
                                                :chart => {
                                                    :caption => 'Movie spread by MPAA Rating',
                                                    :subCaption => 'UFMDb',
                                                    :startingAngle => "120",
                                                    :showLabels => "0",
                                                    :showLegend => "1",
                                                    :enableMultiSlicing => "0",
                                                    :slicingDistance => "15",
                                                    :showPercentValues => "1",
                                                    :showPercentInTooltip => "0",
                                                    :plotTooltext => "MPAA Rating : $label Total Movie Count : $datavalue",
                                                    :theme => 'ocean'
                                                },
                                                :data => mov
                                            }
                                        })
  end



  def runtime
    sql = "select t.run_time as label , count(*) as value
from
(select case
when run_time_minutes >= 30 and run_time_minutes <60 then '30-60'
when run_time_minutes >= 60 and run_time_minutes <120 then '60-120'
when run_time_minutes >= 120 and run_time_minutes <180 then '120-180'
when run_time_minutes >= 180 and run_time_minutes <240 then '180-240'
when run_time_minutes >= 240 and run_time_minutes <300 then '240-300'
when run_time_minutes >= 300 and run_time_minutes <360 then '300-360'
when run_time_minutes >= 360  then '>60'end as run_time
 from movies) t
 group by t.run_time
 "
    @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
    mov = []
    @year_count.each do |yc|
      yc["label"] = yc["label"].to_s
      yc["value"] = yc["value"].to_s
      mov << yc
    end

    mov.to_json
    @barchart = Fusioncharts::Chart.new({
                                            :height => 400,
                                            :width => 600,
                                            :id => 'chart',
                                            :type => 'column2d',
                                            :renderAt => 'chart-container',
                                            :dataSource => {
                                                :chart => {
                                                    :caption => 'Movie runtime stats',
                                                    :subCaption => 'UFMDb',
                                                    :xAxisname => 'Runtime range',
                                                    :yAxisName => 'Movie Count',
                                                    :theme => 'ocean'
                                                },
                                                :data => mov
                                            }
                                        })
  end


  def language
    sql = "select t.label, t.value
from
(select movie_language as label, count(*) as value
from movies
group by movie_language
order by count(*) desc) t
where rownum <=10
 "
    @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
    mov = []
    @year_count.each do |yc|
      yc["label"] = yc["label"].to_s
      yc["value"] = yc["value"].to_s
      mov << yc
    end

    mov.to_json
    @barchart = Fusioncharts::Chart.new({
                                            :height => 400,
                                            :width => 600,
                                            :id => 'chart',
                                            :type => 'column2d',
                                            :renderAt => 'chart-container',
                                            :dataSource => {
                                                :chart => {
                                                    :caption => 'Movie runtime stats',
                                                    :subCaption => 'UFMDb',
                                                    :xAxisname => 'Language',
                                                    :yAxisName => 'Movie Count',
                                                    :theme => 'ocean'
                                                },
                                                :data => mov
                                            }
                                        })
  end
  

end
