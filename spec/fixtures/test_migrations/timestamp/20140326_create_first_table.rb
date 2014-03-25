Sequel.migration do
  up do
    create_table(:first) do
      primary_key :id
      String :value, :null=>false
    end
  end

  down do
    drop_table(:first)
  end
end