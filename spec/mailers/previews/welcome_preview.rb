# Preview all emails at http://localhost:3000/rails/mailers/welcome
class WelcomePreview < DefaultPreview
  def send_to_owner
    WelcomeMailer.send_to_owner(Owner.last || create(:owner))
  end
end
