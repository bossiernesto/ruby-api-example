Sequel.migration do
  change do
    rename_column :users, :password, :password_digest
  end
end
