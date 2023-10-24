require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    sleep 1
    @order = FactoryBot.build(:order_address, user_id: user.id, item_id: item.id)
  end

  context '内容に問題ない場合' do
    it 'すべての値が正しく入力されていれば保存できること' do
      expect(@order).to be_valid
    end
    it 'buildingは空でも保存できること' do
      @order.building = ''
      expect(@order).to be_valid
    end
  end

  context '内容に問題がある場合' do
    it 'tokenが空では保存できないこと' do
      @order.token = nil
      @order.valid?
      expect(@order.errors.full_messages).to include("Token can't be blank")
    end
    it '郵便番号が空だと保存できないこと' do
      @order.postal_code = ''
      @order.valid?
      expect(@order.errors.full_messages).to include("Postal code can't be blank")
    end
    it '郵便番号が半角のハイフンを含んだ正しい形式でないと保存できないこと' do
      @order.postal_code = '1234567'
      @order.valid?
      expect(@order.errors.full_messages).to include('Postal code is invalid. Enter it as follows (e.g. 123-4567)')
    end
    it '都道府県を選択していないと保存できないこと' do
      @order.prefecture_id = 1
      @order.valid?
      expect(@order.errors.full_messages).to include("Prefecture can't be blank")
    end
    it '市区町村が空では保存できないこと' do
      @order.city = ''
      @order.valid?
      expect(@order.errors.full_messages).to include("City can't be blank")
    end
    it '番地が空では保存できないこと' do
      @order.block = ''
      @order.valid?
      expect(@order.errors.full_messages).to include("Block can't be blank")
    end
    it '電話番号が空では保存できないこと' do
      @order.phone_number = ''
      @order.valid?
      expect(@order.errors.full_messages).to include("Phone number can't be blank")
    end
    it '電話番号が半角数値のみ保存可能なこと' do
      @order.phone_number = '123-456-789'
      @order.valid?
      expect(@order.errors.full_messages).to include('Phone number is invalid. Input only numbers')
    end
    it '電話番号が9桁以下では購入できない' do
      @order.phone_number = '123456789'
      @order.valid?
      expect(@order.errors.full_messages).to include('Phone number is too short')
    end
    it '電話番号が12桁以上では購入できない' do
      @order.phone_number = '012345678910'
      @order.valid?
      expect(@order.errors.full_messages).to include('Phone number is too long')
    end
    it 'userが紐付いていないと保存できないこと' do
      @order.user_id = nil
      @order.valid?
      expect(@order.errors.full_messages).to include("User can't be blank")
    end
    it 'itemが紐付いていないと保存できないこと' do
      @order.item_id = nil
      @order.valid?
      expect(@order.errors.full_messages).to include("Item can't be blank")
    end
  end
end
