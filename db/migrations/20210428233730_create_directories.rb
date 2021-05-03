Hanami::Model.migration do
  change do
    create_table :directories do
      primary_key :id

      # column :name, String, null: false
      column :path, String, null: false, unique: true
      column :status, String, null: false, default: 'unsynced'

      # foreign_key :parent_id, :directories, on_delete: :cascade

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
