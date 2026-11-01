class Members::IndexPage < MainLayout
  needs operation : CreateMember
  needs members : Array(User)
  needs standings : Hash(Int64, Progression::Standing)
  needs schools : Array(School)

  def page_title
    "Famille"
  end

  def content
    h1 "Famille"
    mount Members::List, members: members, standings: standings, schools: schools, words: words
    mount Members::NewForm, operation: operation
    mount Members::SchoolList, schools: schools
  end
end
