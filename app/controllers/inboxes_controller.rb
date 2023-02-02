class InboxesController < ApplicationController
  before_action :clear_flash_messages
  before_action :set_inbox, only: %i[ show edit update destroy ]

  def index
    @inboxes = Inbox.all
  end

  def show
  end

  def new
    @inbox = Inbox.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    @inbox = Inbox.new(inbox_params)
    respond_to do |format|
      if @inbox.save
        flash[:notice] = 'Inbox successfully created.'
      else
        flash[:alert] = @inbox.errors.full_messages.to_sentence
      end
      format.turbo_stream
    end
  end

  def update
    respond_to do |format|
      if @inbox.update(inbox_params)
        flash[:notice] = 'Inbox successfully updated.'
      else
        flash[:alert] = @inbox.errors.full_messages.to_sentence
      end
      format.turbo_stream
    end
  end

  def destroy
    respond_to do |format|
      if @inbox.destroy
        flash[:notice] = 'Inbox successfully deleted.'
      else
        flash[:alert] = @inbox.errors.full_messages.to_sentence
      end
      format.turbo_stream
    end
  end

  private

  def clear_flash_messages
    flash.clear
  end

  def set_inbox
    @inbox = Inbox.find(params[:id])
  end

  def inbox_params
    params.require(:inbox).permit(:name)
  end
end
