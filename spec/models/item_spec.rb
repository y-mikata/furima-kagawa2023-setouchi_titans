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
      end
      it 'infoが空では保存できない' do
      end
      it 'imageが空では保存できない' do
      end
      it 'priceが空では保存できない' do
      end
      it 'priceが半角数値でないと保存できない' do
      end
      it 'priceが300未満だと保存できない' do
      end
      it 'priceが9,999,999より大きいと保存できない' do
      end
      it 'が空では保存できない' do
      end
      it 'category_idが --- では保存できない' do
      end
      it 'condition_idが --- では保存できない' do
      end
      it 'postage_type_idが --- では保存できない' do
      end
      it 'prefectuire_idが --- では保存できない' do
      end
      it 'shipping_time_idが --- では保存できない' do
      end
      it 'ユーザーが紐付いていなければ保存できない' do
      end
    end
  end
end