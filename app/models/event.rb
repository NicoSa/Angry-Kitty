class Event < ActiveRecord::Base

  belongs_to :organiser, :class_name => 'User', :foreign_key => "organiser_id"

  has_many :users, through: :debts
  has_many :debts, dependent: :destroy

  validates :organiser_id, presence: true
  validates :deadline, presence: true
  validates :total, presence: true
  validates :title, presence: true

  has_and_belongs_to_many :userinvitees, after_add: :payment_calculator
  accepts_nested_attributes_for :userinvitees, allow_destroy: true, reject_if: :email_blank

  # after_create :payment_calculator
  after_create :remove_organiser_from_invitees

  def payment_calculator(new_invitee)
    if total && userinvitees.any?
      self.payment_amount = self.total / self.userinvitees.length
      self.save
    end
    return true
  end

  def invite!
    self.userinvitees.each do |invitee|
      InvitationMailer.invite(invitee, self).deliver!
    end
  end

  def send_confirmation_emails(debt)
    ConfirmationMailer.celebration(debt.event).deliver!
    ConfirmationMailer.receipt(debt).deliver!
    ConfirmationMailer.notification(debt).deliver!
  end

  def percentage_of_paid
    (self.debts.where(paid: true).size / self.userinvitees.size.to_f) * 100
  end

  def unconfirmed_participants
    self.userinvitees_count - self.users_count
  end

  def users_count
    self.users.count
  end

  def userinvitees_count
    self.userinvitees.count
  end

  def remove_organiser_from_invitees
    invited_organiser = userinvitees.find_by(email: organiser.email)
    userinvitees.delete(invited_organiser) if invited_organiser
  end

  private


  def email_blank(attributes)
    attributes['email'].blank?
  end
end
