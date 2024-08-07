class BrandsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @locations = Location.all
    @brands = Brand.order(rating: :desc, name: :asc)
    @page_brands = true

    if params[:query].present?
      sql_subquery = <<~SQL
        brands.name ILIKE :query
        OR brands.menu::text ILIKE :query
        OR categories.name ILIKE :query
      SQL
      @brands = @brands.joins(:category).where(sql_subquery, query: "%#{params[:query]}%")
    end

    @location = [session[:lat], session[:lng]]
    respond_to do |format|
      format.html
      format.text { render partial: "brands/list", locals: {brands: @brands, user_location: @location }, formats: [:html] }
    end
  end

  def get_user_location
    @brands = Brand.order(rating: :desc, name: :asc)
    respond_to do |format|
      format.text { render partial: "brands/list", locals: {brands: @brands, user_location: [session[:lat], session[:lng]]}, formats: [:html] }
    end
  end

  def set_user_location
    @brands = Brand.order(rating: :desc, name: :asc)
    current_user.update(
      latitude: params[:user_location][:latitude],
      longitude: params[:user_location][:longitude]
    )

    session[:lat] = current_user.latitude
    session[:lng] = current_user.longitude

    p "Locaton is #{location}"

    respond_to do |format|
      format.text { render partial: "brands/list", locals: {brands: @brands, user_location: [session[:lat], session[:lng]]}, formats: [:html] }
    end
  end

  def show
    @locations = Location.all
    @brand = Brand.find(params[:id])
    @location = @brand.locations.first
    @categories = Category.all
    @page_brands = true
  end

  def map
    # if there is a location in the params, we only use that for the marker
    @brand = Brand.all
    if params[:address]
      @locations = Location.where(address: params[:address])
    else
      @locations = Location.all
    end
    @page_map_brands = true

    @markers = @locations.geocoded.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {location: location}),
        marker_html: render_to_string(partial: "marker")
      }
    end
  end

  def increment
    brand = Brand.find(params[:id])
    user = User.find(params[:user_id])
    @card = user.cards.find_by(brand_id: brand.id)

    if @card
      @card.stamps += 1
      # Increments the card's stamps by 1 for visual purposes
      if @card.stamps == @card.brand.card_styles[0].max_stamps
        # Checks card's stamps are equal to the max_stamps for the brand
        @reward = Reward.new(card_id: @card.id)
        @reward.save
        @reward.generate_qrcode
        # Reward is created and QR code is generated
        @card.stamps = 7
        @card_partial = render_to_string(partial: 'card', card: @card)
        @card.stamps = 0
        # Card is temporarily set to 7 for visual purposes, then reset to 0
      else
        @card.stamps -= 1
        @card_partial = render_to_string(partial: 'card', card: @card)
        @card.stamps += 1
        # Card is temporarily decremented by 1 for visual purposes, then incremented by 1
      end
      @card.save
      # Card object is saved to persist the updated count
    end

    @alert = render_to_string(partial: 'alert', reward: @reward, card: @card)

    respond_to do |format|
      format.json
    end
    # Returns the data as JSON
  end

  def user_brand(user)
    @user = user
  end

  def new
    @brand = Brand.new
    @brand.locations.build
    @themes = ['red', 'gold', 'navy-blue', 'sky-blue', 'grass', 'space-grey', 'coral', 'silver']
  end

  def create
    @brand = Brand.new(brand_params)
    @brand.user_id = current_user.id
    @location = Location.new(brand_params[:locations_attributes]['0'])
    @style = CardStyle.new({theme: params[:brand][:card_style][:theme], background: params[:brand][:card_style][:background], max_stamps: 8})
    @location.brand = @brand
    @style.brand = @brand
    if @brand.save && @location.save && @style.save
      redirect_to user_path(current_user), notice: "brand created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @brand = Brand.find(params[:id])
    @location = Location.new
  end

  def update
    @brand = Brand.find(params[:id])
    @brand.update(brand_params)
    redirect_to user_path(current_user)
  end

  private

  def brand_params
    params.require(:brand).permit(:category_id, :name, :description, :menu, :website, :rating, :card_style_id, :reward_type_id, :user_id, :photo, locations_attributes: [:address, :phone_number])
  end
end
