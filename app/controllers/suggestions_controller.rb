class SuggestionsController < ApplicationController
  def index
    @suggestions = current_user.suggestions.pending.includes(:engagement)
  end

  def update
    @suggestion = current_user.suggestions.where(id: params[:id]).take
    if @suggestion.update(suggestion_params)
      flash[:notice] = 'Suggestion was dismissed'
      redirect_to suggestions_path
    else
      flash[:notice] = 'There was a problem updating the suggestion'
      redirect_to suggestions_path
    end
  end

  private

  def suggestion_params
    params.require(:suggestion)
          .permit(:status)
  end
end
