class TrelloCredentialsController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
    @trello_credential = @user.trello_credential
  end

  def edit
    @user = current_user
    redirect_to(new_trello_credentials_path) if @user.trello_credential.nil?
    @trello_credential = @user.trello_credential
  end

  def new
    @trello_credential = TrelloCredential.new
  end

  def update
    puts 'Creds: ' + params[:trello_credential].to_s
    @user = current_user
    @user.trello_credential.trello_key = params[:trello_credential]['trello_key']
    @user.trello_credential.trello_token = params[:trello_credential]['trello_token']
    @user.trello_credential.save
    @user.save
    redirect_to trello_credentials_path
  end

  def create
    @user = current_user
    @trello_credential = TrelloCredential.new
    @trello_credential.trello_key = params[:trello_credential]['trello_key']
    @trello_credential.trello_token = params[:trello_credential]['trello_token']
    @trello_credential.save
    @user.trello_credential = @trello_credential
    @user.save
    redirect_to trello_credentials_path
  end

  private

  def trello_credential_params
    params.require(:trello_credential_params).permit(:trello_key, :trello_token)
  end
end
