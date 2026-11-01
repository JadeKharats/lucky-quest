class Quests::IndexPage < MainLayout
  needs operation : CreateQuest
  needs members : Array(QuestBoard::Row)

  def page_title
    "Quêtes"
  end

  def content
    h1 "Quêtes"
    members.each { |row| mount Quests::MemberQuests, row: row }
    mount Quests::NewForm, operation: operation, members: members.map(&.member)
    mount Raids::Admin, rows: QuestBoard.raids, members: members.map(&.member)
  end
end
