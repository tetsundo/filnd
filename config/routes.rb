Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
get 'trends' => 'films#trends'
get 'casts/:id' => 'films#casts', as: 'casts'
get 'search' => 'films#search', as: 'search'
get 'lists' => 'films#lists', as: 'lists'
end
