class CardsController < ApplicationController
  def index
    @cards = current_user.cards
    @categories = {}

    @cards.each do |card|
      if @categories[card.brand.category.name]
        @categories[card.brand.category.name] << card
      else
        @categories[card.brand.category.name] = [card]
      end
    end

    @page_cards = true
  end

  def create
    @brand = Brand.find(params[:brand_id])
    @card = Card.new
    @card.brand = @brand
    @card.user = current_user
    @card.save
    head :ok
  end
end
