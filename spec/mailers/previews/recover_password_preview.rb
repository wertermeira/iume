# Preview all emails at http://localhost:3000/rails/mailers/recover_password
class RecoverPasswordPreview < DefaultPreview
  def send_to_owner
    RecoverPasswordMailer.send_to_owner(owner: Owner.last || create(:owner), token: 'xxxxxxx')
  end
end
