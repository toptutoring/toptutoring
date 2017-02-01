class RunSeeds < ActiveRecord::Migration[5.0]
  # Prod seeds have been updated with new models and attributes.
  def change
    #Rake::Task['prod:seed'].invoke
  end
end
