class Store::ProductsController < ApplicationController
  # GET /store/products
  # GET /store/products.json
  def index
    @store_products = Store::Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @store_products }
    end
  end

  # GET /store/products/1
  # GET /store/products/1.json
  def show
    @store_product = Store::Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store_product }
    end
  end

  # GET /store/products/new
  # GET /store/products/new.json
  def new
    @store_product = Store::Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store_product }
    end
  end

  # GET /store/products/1/edit
  def edit
    @store_product = Store::Product.find(params[:id])
  end

  # POST /store/products
  # POST /store/products.json
  def create
    @store_product = Store::Product.new(params[:store_product])

    respond_to do |format|
      if @store_product.save
        format.html { redirect_to @store_product, notice: 'Product was successfully created.' }
        format.json { render json: @store_product, status: :created, location: @store_product }
      else
        format.html { render action: "new" }
        format.json { render json: @store_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /store/products/1
  # PUT /store/products/1.json
  def update
    @store_product = Store::Product.find(params[:id])

    respond_to do |format|
      if @store_product.update_attributes(params[:store_product])
        format.html { redirect_to @store_product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store/products/1
  # DELETE /store/products/1.json
  def destroy
    @store_product = Store::Product.find(params[:id])
    @store_product.destroy

    respond_to do |format|
      format.html { redirect_to store_products_url }
      format.json { head :no_content }
    end
  end
end
