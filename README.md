# README

# テーブル設計

## users テーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| first_name         | string | null: false               |
| last_name          | string | null: false               |
| first_name_kana    | string | null: false               |
| last_name_kana     | string | null: false               |
| birthday           | date   | null: false               |

### Association

- has_many :items
- has_many :orders

## items テーブル

| Column        | Type       | Options                        |
| ------------- | ---------- | ------------------------------ |
| name          | string     | null: false                    |
| info          | text       | null: false                    |
| category      | string     | null: false                    |
| condition     | string     | null: false                    |
| price         | integer    | null: false                    |
| postage_type  | string     | null: false                    |
| location      | string     | null: false                    |
| shipping_time | string     | null: false                    |
| user          | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :order

## orders テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| item   | references | null: false, foreign_key: true |
| user   | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

## addresses テーブル

| Column       | Type    | Options     |
| ------------ | ------- | ----------- |
| postal_code  | integer | null: false |
| prefecture   | integer | null: false |
| city         | string  | null: false |
| block_number | string  | null: false |
| building     | string  |
| phone_number | integer | null: false |

### Association

- belongs_to :order
