class Api::V1::MotorcyclesController < ApplicationController
  before_action :set_motorcycle, only: %i[show update destroy]

  def show
    render json: @motorcycle.as_json(methods: :image_url)
  end

  def index
    @motorcycles = Motorcycle.all
    render json: @motorcycles.as_json(methods: :image_url)
  end

  def create
    @motorcycle = Motorcycle.new(motorcycle_params)

    if @motorcycle.save
      render json: @motorcycle, status: :created
    else
      render json: @motorcycle.errors, status: :unprocessable_entity
    end
  end

  def update
    @motorcycle.image.attach(params[:image]) if params[:image]

    if @motorcycle.update(motorcycle_params)
      render json: @motorcycle.to_json(methods: :image_url)
    else
      render json: @motorcycle.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @motorcycle.nil?
      render json: { error: 'Motorcycle not found' }, status: :not_found
    else
      @motorcycle.reservations.destroy_all
      @motorcycle.destroy
      head :no_content
    end
  end

  private

  def set_motorcycle
    @motorcycle = Motorcycle.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Motorcycle not found' }, status: :not_found
  end

  def motorcycle_params
    params.require(:motorcycle).permit(:name, :description, :model_year, :price, :engine, :fuel_type, :image)
  end
end
