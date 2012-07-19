Date::DATE_FORMATS[:dowesd] = lambda do |date|
  date.strftime("%a, #{date.day.ordinalize} %B")
end
