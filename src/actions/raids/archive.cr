class Raids::Archive < BrowserAction
  include Auth::RequireFamilyManager

  post "/raids/:raid_id/archive" do
    raid = RaidQuery.active.find(raid_id)
    Raid::SaveOperation.update!(raid, archived_at: Time.utc)
    flash.success = "Raid « #{raid.title} » archivé."
    redirect Quests::Index
  end
end
