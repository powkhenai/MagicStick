Sequel.migration do
  up do
    create_table?(:seasons) do
      primary_key :id
      String :name, :null => false, :size => 64
      DateTime :created, :null => false
      DateTime :starts, :null => false
      DateTime :ends, :null => false
      String :description, :null => true, :size => 4000
      FalseClass :archived, :null => false, :default => false
      FalseClass :invite_only, :null => false, :default => false
      TrueClass :allow_auto_join, :null => false, :default => true
      foreign_key :owner_id, :users, :null => false, :on_delete => :cascade, :on_update => :cascade
      index [:owner_id, :name]
    end
    create_table?(:season_match_groups) do
      primary_key :id
      String :name, :null => false, :size => 64
      foreign_key :season_id, :seasons, :null => false, :on_delete => :cascade, :on_update => :cascade
      index [:name, :season_id]
    end
    create_table?(:users_seasons) do
      primary_key :id
      foreign_key :user_id, :users, :on_delete => :cascade, :on_update => :cascade
      foreign_key :season_id, :seasons, :on_delete => :cascade, :on_update => :cascade
      index [:user_id, :season_id]
    end    
    create_table?(:matches) do
      primary_key :id
      DateTime :scheduled_for, :null => false
      DateTime :completed, :null => true
      foreign_key :season_match_group_id, :season_match_group, :null => false, :on_delete => :cascade, :on_update => :cascade
      String :description, :null => true, :size => 4000
    end
    create_table?(:users_seasons_matches) do
      TrueClass :won, :null => true
      foreign_key :user_season_id, :users_seasons, :on_delete => :cascade, :on_update => :cascade
      foreign_key :match_id, :matches, :on_delete => :cascade, :on_update => :cascade
      primary_key [:user_season_id, :match_id]
      index [:user_season_id, :match_id]
    end
    create_table?(:matches_comments) do
      primary_key :id
      foreign_key :user_id, :users, :on_delete => :cascade, :on_update => :cascade
      foreign_key :match_id, :matches, :on_delete => :cascade, :on_update => :cascade
      DateTime :created, :null => false
      DateTime :updated, :null => true
      String :comment, :null => false, :size => 4000
      FalseClass :hidden, :null => false, :default => false
    end
    create_table?(:seasons_comments) do
      primary_key :id
      foreign_key :user_id, :users, :on_delete => :cascade, :on_update => :cascade
      foreign_key :season_id, :seasons, :on_delete => :cascade, :on_update => :cascade
      DateTime :created, :null => false
      DateTime :updated, :null => true
      String :comment, :null => false, :size => 4000
      FalseClass :hidden, :null => false, :default => false      
    end
  end
  down do
    drop_table(:seasons_comments, :matches_comments, :users_seasons_matches, :matches, :users_seasons, :season_match_groups, :seasons)
  end
end
