class SidebarListController < ApplicationController
 before_action :set_movie, only: [:displaySidebarList]
  
  def displaySidebarList
  end

  def show
  	 @chart = Fusioncharts::Chart.new({
        width: "600",
        height: "400",
        type: "mscolumn2d",
        renderAt: "chartContainer",
        dataSource: {
            chart: {
            caption: "Comparison of Quarterly Revenue",
            subCaption: "Harry's SuperMart",
            xAxisname: "Quarter",
            yAxisName: "Amount ($)",
            numberPrefix: "$",
            theme: "fint",
            exportEnabled: "1",
            },
            categories: [{
                    category: [
                        { label: "Q1" },
                        { label: "Q2" },
                        { label: "Q3" },
                        { label: "Q4" }
                    ]
                }],
                dataset: [
                    {
                        seriesname: "Previous Year",
                        data: [
                            { value: "10000" },
                            { value: "11500" },
                            { value: "12500" },
                            { value: "15000" }
                        ]
                    },
                    {
                        seriesname: "Current Year",
                        data: [
                            { value: "25400" },
                            { value: "29800" },
                            { value: "21800" },
                            { value: "26800" }
                        ]
                    }
              ]
        }
    })
  end

  def set_movie
      sql = "select primary_title,genres,start_year, poster from movies where ROWNUM <= 3"
      @movie = ActiveRecord::Base.connection.exec_query(sql).to_a

      #@movie = Movie.find(params[:id])
      #@rating = Rating.find(params[:id])
    end
end
