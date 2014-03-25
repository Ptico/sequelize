Sequel.migration do
  up do
    create_table(:second) do
      primary_key :id
      String :value, :null=>false
    end
  end

  down do
    drop_table(:second)
  end
end