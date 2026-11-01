class AccessLinks::InvalidPage < AuthLayout
  def page_title
    "Lien expiré"
  end

  def content
    h1 "Lien expiré"
    para "Ce lien n'est plus valable : demande-en un nouveau à un parent."
  end
end
