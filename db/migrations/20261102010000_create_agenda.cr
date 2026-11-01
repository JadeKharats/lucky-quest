class CreateAgenda::V20261102010000 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Activity) do
      primary_key id : Int64
      add_timestamps
      add title : String
      add place : String, default: ""
      add starts_on : Time
      add last_day : Time?
      add start_minutes : Int32
      add end_minutes : Int32
      add weekly : Bool
      add needs_ride : Bool
      add_belongs_to driver_to : User?, on_delete: :nullify
      add_belongs_to driver_back : User?, on_delete: :nullify
    end

    create table_for(ActivityParticipant) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to activity : Activity, on_delete: :cascade
      add_belongs_to user : User, on_delete: :cascade
    end
    create_index :activity_participants, [:activity_id, :user_id], unique: true

    create table_for(ActivityChange) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to activity : Activity, on_delete: :cascade
      add day : Time
      add cancelled : Bool, default: false
      add drivers_overridden : Bool, default: false
      add_belongs_to driver_to : User?, on_delete: :nullify
      add_belongs_to driver_back : User?, on_delete: :nullify
    end
    create_index :activity_changes, [:activity_id, :day], unique: true

    alter table_for(User) do
      add calendar_token_digest : String?, unique: true
    end
  end

  def rollback
    alter table_for(User) do
      remove :calendar_token_digest
    end
    drop table_for(ActivityChange)
    drop table_for(ActivityParticipant)
    drop table_for(Activity)
  end
end
