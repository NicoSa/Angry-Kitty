class UserinviteesController < ApplicationController
  def show
    @event = Event.find(params[:event_id])
    @userinvitee = Userinvitee.find(params[:userinvitee_id])
    @user = User.find_by(email: @userinvitee.email)

    if @user.nil?
      session[:event_id] = params[:event_id]
      session[:userinvitee_id] = params[:userinvitee_id]
      redirect_to new_user_registration_path
    else
      sign_in(:user, @user)
      @user.events << @event
      redirect_to @event
    end

  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "already in the event!"
    redirect_to @event
  end

  def edit
    @event = Event.find(params[:event_id])
    @userinvitee = Userinvitee.find(params[:id])
  end

  def update
    @userinvitee = Userinvitee.find(params[:id])
    @event = Event.find(params[:event_id])

    # if @userinvitee.update(params[:userinvitee].permit(:name, :email, :mobile))
    #  # @restaurant.update(params[:restaurant].permit(:name, :address, :cuisine))
    #   redirect_to "/events/#{@event.id}"
    # else
    #   render 'edit'
    # end

    if params[:resend]
      @userinvitee.update(params[:userinvitee].permit(:name, :email, :mobile))
      InvitationMailer.invite(@userinvitee, @event).deliver!
      redirect_to "/events/#{@event.id}"
    else
      @userinvitee.update(params[:userinvitee].permit(:name, :email, :mobile))
      redirect_to "/events/#{@event.id}"
    end

  end

  def destroy
    @event = Event.find(params[:event_id])
    userinvitee = Userinvitee.find(params[:id])
    userinvitee.destroy
    redirect_to(event_path(@event))
  end
end