include: "/views/**/*.view" # include all the views

# Place in `thelook` model
explore: +order_items {
  query: high_value_geos {
    label: "地域分析"
    description: "過去90日間に高い粗利率を記録した州"
    dimensions: [users.state]
    measures: [total_gross_margin]
    sorts: [total_gross_margin: desc]
    filters: [
      inventory_items.created_date: "90 days",
      order_items.total_gross_margin: ">=10000",
      users.country: "USA"
    ]
  }
}


explore: +order_items {
  query: year_over_year {
    label: "売上の年度比較"
    description: "直近4年間の月次売上比較（折れ線グラフ用）"
    dimensions: [created_month_num, created_year]
    pivots: [created_year]
    measures: [total_sale_price]
    sorts: [created_month_num: asc]
    filters: [
      order_items.created_date: "before 0 months ago",
      order_items.created_year: "4 years"
    ]
  }
}

explore: +order_items {
  query: shipments_status {
    label: "配送ステータス"
    description: "配送パイプラインの要約"
    dimensions: [created_date, status]
    pivots: [status]
    measures: [order_count]
    filters: [
      distribution_centers.name: "Chicago IL",
      order_items.created_date: "60 days",
      order_items.status: "Complete,Shipped,Processing"
    ]
  }
}

explore: +order_items {
  query: inventory_aging {
    label: "在庫期間と在庫量"
    description: "在庫期間別の在庫量"
    dimensions: [inventory_items.days_in_inventory_tier]
    measures: [inventory_items.count]
    filters: [distribution_centers.name: "Chicago IL"]
    #timezone: "America/Los_Angeles"
  }
}

# Place in `thelook` model
explore: +order_items {
  query: severely_delayed_orders {
    label: "遅延している処理"
    description: "処理中のまま3日以上経過した注文（配送センターでフィルター可）"
    dimensions: [created_date, order_id, products.item_name, status, users.email]
    measures: [average_days_to_process]
    filters: [
      distribution_centers.name: "Chicago IL",
      order_items.created_date: "before 3 days ago",
      order_items.status: "Processing"
    ]
  }
}
