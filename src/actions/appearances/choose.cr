class Appearances::Choose < BrowserAction
  post "/apparence" do
    ChooseSkin.update(current_user, params) do |operation, member|
      if operation.saved?
        flash.success = "Apparence « #{Lexicon.name(member.skin)} » choisie."
      else
        flash.failure = "Cette apparence n'existe pas."
      end
      redirect Home::Index
    end
  end
end
