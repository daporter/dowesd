def full_title(page_title)
  base_title = "D Owes D"
  page_title.empty? ? base_title : "#{base_title} | #{page_title}"
end
