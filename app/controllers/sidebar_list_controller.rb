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

    #sql = "Select poster, primary_title, start_year, rating From movies m, ratings r Where m.movie_id = r.movie_id and r.rating >=" + rating.to_s + " and m.start_year = " + year.to_s + " order by r.rating " + sort_by.to_s
    #@movie = ActiveRecord::Base.connection.exec_query(sql).to_a

    sql ="select m.START_YEAR as label
     from movies m,
(select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
where m.movie_id = b.movie_id and b.bo > b1.avg1
group by m.START_YEAR order by m.START_YEAR"
   @year_count = ActiveRecord::Base.connection.exec_query(sql).to_a

    sql ="select count(*) as value
     from movies m,
(select movie_id,cast(replace(substr(boxoffice,2),',','')as NUMERIC) as bo from boxoffice) b, (select avg(cast(replace(substr(boxoffice,2),',','')as NUMERIC)) as avg1 from boxoffice) b1
where m.movie_id = b.movie_id and b.bo > b1.avg1
group by m.START_YEAR order by m.START_YEAR"
    @year_count1 = ActiveRecord::Base.connection.exec_query(sql).to_a

    @temp1 = @year_count
    @temp2 = @year_count
    mov = []

    @year_count.each do |yc|
      yc["label"] = yc["label"].to_s
      mov << yc
    end

    puts mov.to_json


    mov1=[]

    @year_count1.each do |yc|
      yc["value"] = yc["value"].to_s
      mov1 << yc
    end

    puts mov1.to_json

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

  def temp

    year = params[:year]
    rating = params[:rating]
    sort_by = params[:sort_by]

    sql = "Select poster, primary_title, start_year, rating From movies m, ratings r Where m.movie_id = r.movie_id and r.rating >=" + rating.to_s + " and m.start_year = " + year.to_s + " order by r.rating " + sort_by.to_s
    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

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
    sql = "Select * from (Select poster, primary_title, start_year, rating From movies m, ratings r Where m.movie_id = r.movie_id order by r.rating DESC) where ROWNUM<=10"
    @movie = ActiveRecord::Base.connection.exec_query(sql).to_a
  end

end
