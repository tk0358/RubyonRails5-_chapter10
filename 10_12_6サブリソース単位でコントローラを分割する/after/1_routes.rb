# config/routes.rb

resources :order_reports, only: %i(index show)
resources :order_csvs, only: %i(index create)
