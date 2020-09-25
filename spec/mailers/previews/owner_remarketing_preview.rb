# Preview all emails at http://localhost:3000/rails/mailers/owner_remarketing
class OwnerRemarketingPreview < DefaultPreview
  def send_to_owner
    OwnerRemarketingMailer.send_to_owner(Owner.last || create(:owner))
  end
end
