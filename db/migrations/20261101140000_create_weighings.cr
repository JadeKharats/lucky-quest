class CreateWeighings::V20261101140000 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Weighing) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade
      add measured_at : Time
      add kilograms : Float64
    end
  end

  def rollback
    drop table_for(Weighing)
  end
end
