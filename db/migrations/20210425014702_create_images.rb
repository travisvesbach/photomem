Hanami::Model.migration do
  change do
    create_table :images do
      primary_key :id

      column :name, String, null: false
      column :date_taken, DateTime, null: true
      column :orientation, String, null: true

      foreign_key :directory_id, :directories, on_delete: :cascade

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
