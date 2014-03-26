Sequel.migration do
  change do
    create_table(:second) do
      primary_key :id
      String :value, :null=>false
    end
  end
end