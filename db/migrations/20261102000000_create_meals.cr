class CreateMeals::V20261102000000 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(School) do
      primary_key id : Int64
      add_timestamps
      add name : String
      add days_mask : Int32
    end

    alter table_for(User) do
      add_belongs_to school : School?, on_delete: :nullify
    end

    create table_for(CanteenMeal) do
      primary_key id : Int64
      add_timestamps
      add_belongs_to school : School, on_delete: :cascade
      add day : Time
      add dish : String
      add tag : Int32
    end
    create_index :canteen_meals, [:school_id, :day], unique: true

    create table_for(HomeMeal) do
      primary_key id : Int64
      add_timestamps
      add day : Time
      add slot : Int32
      add dish : String
      add tag : Int32
    end
    create_index :home_meals, [:day, :slot], unique: true

    alter table_for(Quest) do
      add canteen_menu : Bool, default: false
    end
  end

  def rollback
    alter table_for(Quest) do
      remove :canteen_menu
    end
    drop table_for(HomeMeal)
    drop table_for(CanteenMeal)
    alter table_for(User) do
      remove_belongs_to :school
    end
    drop table_for(School)
  end
end
