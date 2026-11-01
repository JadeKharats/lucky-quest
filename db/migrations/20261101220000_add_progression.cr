class AddProgression::V20261101220000 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Quest) do
      add xp : Int32, default: 10
    end
    alter table_for(Raid) do
      add xp : Int32, default: 30
    end

    create table_for(XpEntry) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to user : User, on_delete: :cascade
      add amount : Int32
      add label : String
      add earned_at : Time
      add_belongs_to completion : Completion?, on_delete: :cascade, unique: true
      add_belongs_to raid : Raid?, on_delete: :cascade
      add period_start : Time?
    end
    create_index :xp_entries, [:raid_id, :period_start, :user_id], unique: true

    create table_for(Reward) do
      primary_key id : Int64
      add_timestamps
      add title : String
      add cost : Int32
      add archived_at : Time?
    end

    create table_for(Purchase) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to reward : Reward, on_delete: :cascade
      add_belongs_to user : User, on_delete: :cascade
      add cost : Int32
      add bought_at : Time
      add handed_at : Time?
    end

    # Quests validated before M5 earn their default XP.
    execute "INSERT INTO xp_entries (user_id, amount, label, earned_at, completion_id, created_at, updated_at) " \
            "SELECT quests.user_id, quests.xp, quests.title, completions.validated_at, completions.id, NOW(), NOW() " \
            "FROM completions JOIN quests ON quests.id = completions.quest_id " \
            "WHERE completions.validated_at IS NOT NULL"
  end

  def rollback
    drop table_for(Purchase)
    drop table_for(Reward)
    drop table_for(XpEntry)
    alter table_for(Raid) do
      remove :xp
    end
    alter table_for(Quest) do
      remove :xp
    end
  end
end
