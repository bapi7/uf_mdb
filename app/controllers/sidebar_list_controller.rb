require 'will_paginate/array'
class SidebarListController < ApplicationController
  before_action :set_movie, only: [:template]

  def displaySidebarList
  end

  def index
    sql = "select start_year as label, count(*) as value from movies where start_year > 2000 group by start_year order by start_year"
    @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a
    mov = []
    @year_count.each do |yc|
      yc["label"] = yc["label"].to_s
      yc["value"] = yc["value"].to_s
      mov << yc
    end

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
                                             :data => mov
                                         }
                                     })

  end

  def box2

    #year = params[:year]
    #rating = params[:rating]
    sort_by = params[:sort_by]

    sql = "select poster,primary_title,bo
        from movies m,
                    (select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
    where m.movie_id = b.movie_id and b.bo > b1.avg1
    order by b.bo " + sort_by.to_s

    @hits = ActiveRecord::Base.connection.exec_query(sql).to_a





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
                "caption": "Actual Revenues, Targeted Revenues & Profits",
                "subcaption": "Last year",
                "xaxisname": "Month",
                "yaxisname": "Amount (In USD)",
                "numberprefix": "$",
                "theme": "ocean"
            },
                "categories": [
                    {
                        :category => mov
                    }
                ],
            "dataset": [
                {
                    "seriesname": "Projected Revenue",
                    "renderas": "line",
                    "showvalues": "0",
                    :data => mov1
                },
                {
                    "seriesname": "Projected Revenue",
                    "renderas": "area",
                    "showvalues": "0",
                    :data => mov1
                }

              ]
            }
                                        });

    render :'sidebar_list/boxoffice_hits'
  end

  def paginate
    @movie = @marr.paginate(:page => params[:page],:per_page => 20)
  end

  def temp

    year = params[:year]
    rating = params[:rating]
    sort_by = params[:sort_by]

    sql = "Select poster, primary_title, start_year, rating From movies m, ratings r Where m.movie_id = r.movie_id and r.rating >=" + rating.to_s + " and m.start_year = " + year.to_s + " order by r.rating " + sort_by.to_s
    @marr = ActiveRecord::Base.connection.exec_query(sql).to_a
    @movie = @marr.paginate(:page=> params[:page], :per_page=>15)

    sql = "select case when r.rating >= 0 and r.rating <1 then '0-1' when r.rating >= 1 and r.rating <2 then '1-2' when r.rating >= 2 and r.rating <3 then '2-3' when r.rating >= 3 and r.rating <4 then '3-4' when r.rating >= 4 and r.rating <5 then '4-5' when r.rating >= 5 and r.rating <6 then '5-6' when r.rating >= 6 and r.rating <7 then '6-7' when r.rating >= 7 and r.rating <8 then '7-8' when r.rating >= 8 and r.rating <9 then '8-9' when r.rating >= 9 and r.rating <10 then '9-10' end as label, count(*) as value from (select * from ratings order by rating asc) r group by case when r.rating >= 0 and r.rating <1 then '0-1' when r.rating >= 1 and r.rating <2 then '1-2' when r.rating >= 2 and r.rating <3 then '2-3' when r.rating >= 3 and r.rating <4 then '3-4' when r.rating >= 4 and r.rating <5 then '4-5' when r.rating >= 5 and r.rating <6 then '5-6' when r.rating >= 6 and r.rating <7 then '6-7' when r.rating >= 7 and r.rating <8 then '7-8' when r.rating >= 8 and r.rating <9 then '8-9' when r.rating >= 9 and r.rating <10 then '9-10' end order by label"
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

    render :template
  end


  def celeb_hts

    nom = params[:nom]
    ave = params[:ave]
    sort_by = params[:sort_by]
    sql = "select celebrity_name, l.noofmovies as movie_count , k.hits, avg_rating
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
   @movie = ActiveRecord::Base.connection.exec_query(sql).to_a



    render :celeb_hits
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


  def smpl4

    nom = params[:nom]
    ave = params[:ave]
    sort_by = params[:sort_by]
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
from celebrities where celebrities.CELEBRITY_NAME='Richard Attenborough') and t1.end_year1 <= (select (birth_year+50) 
from celebrities where celebrities.CELEBRITY_NAME='Richard Attenborough')"
    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a



    render :'sidebar_list/celebrity_prime_comp'
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

  def set_movie
    sql = "Select poster, primary_title, start_year, rating From movies m, ratings r Where m.movie_id = r.movie_id order by r.rating DESC"
    @marr = ActiveRecord::Base.connection.exec_query(sql).to_a
    #@movie = @marr.paginate(:page=> 1, :per_page=>15)
    @movie = @marr.paginate(:page => params[:page],:per_page => 20)
  end

  def smpl2

    
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
    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

   
    render :celeb_rating
  end

  def celeb_genre

    
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


    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

   
    render :celeb_rating_genre
  end

   def pop_prod1

    
    rating = params[:rating]
    sort_by = params[:sort_by]

      sql = "select b.production, avg(r.votes) as votes1
from
movies m, boxoffice b, ratings r
where m.movie_id = b.movie_id and m.movie_id = r.movie_id
group by b.production
order by avg(r.votes) " + sort_by.to_s


    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

   
    render :pop_production_votes
  end

def pop_prod2

    
    rating = params[:rating]
    sort_by = params[:sort_by]

      sql = "select b.production, avg(r.rating) as rating1
from
movies m, boxoffice b, ratings r
where m.movie_id = b.movie_id and m.movie_id = r.movie_id
group by b.production
order by avg(r.rating) " + sort_by.to_s


    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

   
    render :pop_production_critic
  end

  def actor_age

    
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
where t1.celebrity_id = t2.celebrity_id and t2.age > 0
order by age  " + sort_by.to_s


    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

   
    render :actor_age_hits
  end

end
