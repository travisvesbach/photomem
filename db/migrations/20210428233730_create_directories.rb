Hanami::Model.migration do
  change do
    create_table :directories do
      primary_key :id

      column :path, String, null: false, unique: true
      column :status, String, null: false, default: 'unsynced'

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
