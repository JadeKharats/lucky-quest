class CreateAccessLinks::V20261101160100 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(AccessLink) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade
      add token_digest : String, unique: true
      add expires_at : Time
      add used_at : Time?
    end
  end

  def rollback
    drop table_for(AccessLink)
  end
end
