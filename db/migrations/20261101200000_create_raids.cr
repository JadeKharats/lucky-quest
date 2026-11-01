class CreateRaids::V20261101200000 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Raid) do
      primary_key id : Int64
      add_timestamps
      add title : String
      add frequency : Int32
      add days_mask : Int32, default: 0
      add archived_at : Time?
    end

    create table_for(RaidStep) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to raid : Raid, on_delete: :cascade
      add position : Int32
      add title : String
      add rule : Int32, default: 0
    end

    create table_for(RaidStepParticipant) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to raid_step : RaidStep, on_delete: :cascade
      add_belongs_to user : User, on_delete: :cascade
    end
    create_index :raid_step_participants, [:raid_step_id, :user_id], unique: true

    create table_for(RaidCheck) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to raid_step : RaidStep, on_delete: :cascade
      add_belongs_to user : User, on_delete: :cascade
      add period_start : Time
      add checked_at : Time
    end
    create_index :raid_checks, [:raid_step_id, :user_id, :period_start], unique: true
  end

  def rollback
    drop table_for(RaidCheck)
    drop table_for(RaidStepParticipant)
    drop table_for(RaidStep)
    drop table_for(Raid)
  end
end
