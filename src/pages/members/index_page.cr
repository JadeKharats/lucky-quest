class Members::IndexPage < MainLayout
  needs operation : CreateMember
  needs members : Array(User)
  needs standings : Hash(Int64, Progression::Standing)

  def page_title
    "Famille"
  end

  def content
    h1 "Famille"
    mount Members::List, members: members, standings: standings
    mount Members::NewForm, operation: operation
  end
end
