require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe 'アイテムの保存' do
    context 'アイテムが保存できる場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@item).to be_valid
      end
    end
    context 'アイテムが保存できない場合' do
      it 'nameが空では保存できない' do
        @item.name = ''
        @item.valid?
        expect(@item.errors.full_messages).to include "Name can't be blank"
      end
      it 'infoが空では保存できない' do
        @item.info = ''
        @item.valid?
        expect(@item.errors.full_messages).to include "Info can't be blank"
      end
      it 'imageが空では保存できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include "Image can't be blank"
      end
      it 'priceが空では保存できない' do
        @item.price = ''
        @item.valid?
        expect(@item.errors.full_messages).to include "Price can't be blank"
      end
      it 'priceが半角数値でないと保存できない' do
        @item.price = 'hankaku'
        @item.valid?
        expect(@item.errors.full_messages).to include "Price is invalid"
      end
      it 'priceが300未満だと保存できない' do
        @item.price = 250
        @item.valid?
        expect(@item.errors.full_messages).to include "Price is invalid"
      end
      it 'priceが9,999,999より大きいと保存できない' do
        @item.price = 11_111_111
        @item.valid?
        expect(@item.errors.full_messages).to include "Price is invalid"
      end
      it 'category_idが --- では保存できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include "Category can't be blank"
      end
      it 'condition_idが --- では保存できない' do
        @item.condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include "Condition can't be blank"
      end
      it 'postage_type_idが --- では保存できない' do
        @item.postage_type_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include "Postage type can't be blank"
      end
      it 'prefectuire_idが --- では保存できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include "Prefecture can't be blank"
      end
      it 'shipping_time_idが --- では保存できない' do
        @item.shipping_time_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include "Shipping time can't be blank"
      end
      it 'ユーザーが紐付いていなければ保存できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('User must exist')
      end
    end
  end
end