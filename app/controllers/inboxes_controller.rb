class InboxesController < ApplicationController
  before_action :clear_flash_messages
  before_action :set_inbox, only: %i[ show edit update destroy ]

  # GET /inboxes or /inboxes.json
  def index
    @inboxes = Inbox.all
  end

  # GET /inboxes/1 or /inboxes/1.json
  def show
  end

  # GET /inboxes/new
  def new
    @inbox = Inbox.new
  end

  # GET /inboxes/1/edit
  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@inbox, partial: 'inboxes/form', locals: { inbox: @inbox })
      end
    end
  end

  # POST /inboxes or /inboxes.json
  def create
    @inbox = Inbox.new(inbox_params)
    respond_to do |format|
      if @inbox.save
        flash[:notice] = 'Inbox successfully created.'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_inbox', partial: 'inboxes/form', locals: { inbox: Inbox.new }),
            turbo_stream.append('inboxes', partial: 'inboxes/inbox', locals: { inbox: @inbox }),
            turbo_stream.update('flash_inbox', partial: 'inboxes/flash')
          ]
        end
        # format.html { redirect_to @inbox }
      else
        flash[:alert] = @inbox.errors.full_messages.to_sentence
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('new_inbox', partial: 'inboxes/form', locals: { inbox: @inbox }),
            turbo_stream.update('flash_inbox', partial: 'inboxes/flash')
          ]
        end
        # format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inboxes/1 or /inboxes/1.json
  def update
    respond_to do |format|
      if @inbox.update(inbox_params)
        flash[:notice] = 'Inbox successfully updated.'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(@inbox, partial: 'inboxes/inbox', locals: { inbox: @inbox }),
            turbo_stream.update('flash_inbox', partial: 'inboxes/flash')
          ]
        end
        # format.html { redirect_to @inbox, notice: "Inbox was successfully updated." }
      else
        flash[:alert] = @inbox.errors.full_messages.to_sentence
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(@inbox, partial: 'inboxes/form', locals: { inbox: @inbox }),
            turbo_stream.update('flash_inbox', partial: 'inboxes/flash')
          ]
        end
        # format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inboxes/1 or /inboxes/1.json
  def destroy
    @inbox.destroy
    flash[:notice] = 'Inbox successfully deleted.'
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@inbox),
          turbo_stream.update('flash_inbox', partial: 'inboxes/flash')
        ]
      end
      # format.html { redirect_to inboxes_url }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def clear_flash_messages
    flash.clear
  end

  def set_inbox
    @inbox = Inbox.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def inbox_params
    params.require(:inbox).permit(:name)
  end
end
