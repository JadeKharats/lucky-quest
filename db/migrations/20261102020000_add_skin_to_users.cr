class AddSkinToUsers::V20261102020000 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      add skin : Int32, default: 0
    end
  end

  def rollback
    alter table_for(User) do
      remove :skin
    end
  end
end
