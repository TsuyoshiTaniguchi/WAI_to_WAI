class Public::HomesController < ApplicationController
  before_action :authenticate_customer!, except: [:top, :about]
  
  def top
  end

  def about
  end
end