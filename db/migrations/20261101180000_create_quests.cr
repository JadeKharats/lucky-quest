class CreateQuests::V20261101180000 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Quest) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade
      add title : String
      add frequency : Int32
      add days_mask : Int32, default: 0
      add archived_at : Time?
    end
  end

  def rollback
    drop table_for(Quest)
  end
end
