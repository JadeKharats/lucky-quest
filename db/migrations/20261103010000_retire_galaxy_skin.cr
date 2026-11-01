# Galaxie (stored value 2) was dropped in M10: its members go back to
# Classique. The value 2 is never reused.
class RetireGalaxySkin::V20261103010000 < Avram::Migrator::Migration::V1
  def migrate
    execute "UPDATE users SET skin = 0 WHERE skin = 2"
  end

  # Nothing to restore: who wore Galaxie is not kept.
  def rollback
  end
end
