Sequel.migration do
  change do
    alter_table(:users) do
      add_column :reset_password_token, String, null: true
      add_column :reset_password_token_exp, DateTime, null: true
    end
  end
end