class Members::IndexPage < MainLayout
  needs operation : CreateMember
  needs members : Array(User)

  def page_title
    "Famille"
  end

  def content
    h1 "Famille"
    mount Members::List, members: members
    mount Members::NewForm, operation: operation
  end
end
