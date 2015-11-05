scope 'projects/:project_id', as: :project do
  resources :daily_reports, except: :show do
    post :save_settings, on: :collection
    get :reload_form, on: :collection
  end
end
