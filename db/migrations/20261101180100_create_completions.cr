class CreateCompletions::V20261101180100 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Completion) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to quest : Quest, on_delete: :cascade
      add period_start : Time
      add done_at : Time
      add validated_at : Time?
      add_belongs_to validated_by : User?, on_delete: :nullify
    end
    # One "C'est fait !" per occurrence.
    create_index :completions, [:quest_id, :period_start], unique: true
  end

  def rollback
    drop table_for(Completion)
  end
end
