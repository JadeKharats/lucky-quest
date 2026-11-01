# Accounts become the household's members. Only parents sign in with an
# e-mail and a password; the others come in with an access link.
class AddFamilyToUsers::V20261101160000 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(User) do
      # The existing account is the owner: a parent, renamed from the Famille page.
      add name : String, fill_existing_with: "Parent"
      add role : Int32, default: 0
      add access_ends_at : Time?
      add session_generation : Int32, default: 0
    end
    make_optional table_for(User), :email
    make_optional table_for(User), :encrypted_password
  end

  def rollback
    execute "DELETE FROM users WHERE email IS NULL"
    make_required table_for(User), :encrypted_password
    make_required table_for(User), :email
    alter table_for(User) do
      remove :session_generation
      remove :access_ends_at
      remove :role
      remove :name
    end
  end
end
