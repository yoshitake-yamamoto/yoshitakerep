- dashboard: customer_segment_insights
  title: 顧客セグメント・購買インサイト分析
  layout: newspaper
  preferred_viewer: dashboards
  description: '年齢区分（未成年・成人・シルバー）をはじめとする顧客属性別の購買動向・売上パフォーマンスを可視化する実用ダッシュボード'
  query_timezone: user_timezone
  elements:
  - name: header_kpi
    type: text
    title_text: "<b>主要業績サマリー (KPI)</b>"
    subtitle_text: "全体の売上規模・取引件数・ユニーク顧客数・平均単価の概況"
    body_text: ''
    row: 0
    col: 0
    width: 24
    height: 2

  - title: 総売上
    name: total_sale_price
    model: thelook_jp
    explore: order_items
    type: single_value
    fields: [order_items.total_sale_price]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: 総売上
    value_format: "$#,##0"
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 2
    col: 0
    width: 6
    height: 4

  - title: 受注件数
    name: order_count
    model: thelook_jp
    explore: order_items
    type: single_value
    fields: [order_items.order_count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: 受注件数
    value_format: "#,##0"
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 2
    col: 6
    width: 6
    height: 4

  - title: 購入顧客数
    name: customer_count
    model: thelook_jp
    explore: order_items
    type: single_value
    fields: [users.count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: 購入顧客数
    value_format: "#,##0"
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 2
    col: 12
    width: 6
    height: 4

  - title: 平均受注単価
    name: average_sale_price
    model: thelook_jp
    explore: order_items
    type: single_value
    fields: [order_items.average_sale_price]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: 平均受注単価
    value_format: "$#,##0.00"
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 2
    col: 18
    width: 6
    height: 4

  - name: header_demographics
    type: text
    title_text: "<b>顧客属性・年代別インサイト</b>"
    subtitle_text: "新設した「年齢区分」を軸にした売上構成比および商品カテゴリー別購買傾向"
    body_text: ''
    row: 6
    col: 0
    width: 24
    height: 2

  - title: 年齢区分別 売上構成比
    name: age_group_sales_share
    model: thelook_jp
    explore: order_items
    type: looker_pie
    fields: [users.age_group, order_items.total_sale_price]
    filters:
      users.age_group: "-EMPTY"
    sorts: [order_items.total_sale_price desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    colors: ["#4285F4", "#34A853", "#FBBC05"]
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 8
    col: 0
    width: 8
    height: 8

  - title: 年齢区分 × 商品カテゴリー別 売上比較
    name: age_group_category_sales
    model: thelook_jp
    explore: order_items
    type: looker_column
    fields: [products.category, users.age_group, order_items.total_sale_price]
    pivots: [users.age_group]
    filters:
      users.age_group: "-EMPTY"
    sorts: [order_items.total_sale_price desc 0]
    limit: 15
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_labels: false
    series_colors:
      未成年 - order_items.total_sale_price: "#4285F4"
      成人 - order_items.total_sale_price: "#34A853"
      シルバー - order_items.total_sale_price: "#FBBC05"
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 8
    col: 8
    width: 16
    height: 8

  - name: header_trends
    type: text
    title_text: "<b>トレンド & 流入チャネル分析</b>"
    subtitle_text: "時系列での売上・年代構成の推移と、獲得チャネル（トラフィックソース）ごとの効率性"
    body_text: ''
    row: 16
    col: 0
    width: 24
    height: 2

  - title: 月別売上推移（年代別内訳）
    name: monthly_sales_by_age_group
    model: thelook_jp
    explore: order_items
    type: looker_column
    fields: [order_items.created_month, users.age_group, order_items.total_sale_price]
    pivots: [users.age_group]
    filters:
      order_items.created_month: 12 months
      users.age_group: "-EMPTY"
    sorts: [order_items.created_month desc, users.age_group]
    limit: 500
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    series_colors:
      未成年 - order_items.total_sale_price: "#4285F4"
      成人 - order_items.total_sale_price: "#34A853"
      シルバー - order_items.total_sale_price: "#FBBC05"
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 18
    col: 0
    width: 16
    height: 8

  - title: 流入チャネル別 顧客数 & 平均単価
    name: traffic_source_analysis
    model: thelook_jp
    explore: order_items
    type: looker_column
    fields: [users.traffic_source, users.count, order_items.average_sale_price]
    sorts: [users.count desc]
    limit: 500
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    series_types:
      order_items.average_sale_price: line
    y_axes:
    - label: 顧客数
      orientation: left
      series:
      - id: users.count
        name: 顧客数
    - label: 平均受注単価
      orientation: right
      series:
      - id: order_items.average_sale_price
        name: 平均受注単価
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 18
    col: 16
    width: 8
    height: 8

  - name: header_products_geo
    type: text
    title_text: "<b>ブランド & エリア別パフォーマンス</b>"
    subtitle_text: "売上上位の主要ブランドと主要州・地域別の売上実績"
    body_text: ''
    row: 26
    col: 0
    width: 24
    height: 2

  - title: 売上上位ブランド TOP 10
    name: top_brands
    model: thelook_jp
    explore: order_items
    type: looker_grid
    fields: [products.brand, order_items.total_sale_price, order_items.order_count, order_items.average_sale_price]
    sorts: [order_items.total_sale_price desc]
    limit: 10
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    series_cell_visualizations:
      order_items.total_sale_price:
        is_active: true
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 28
    col: 0
    width: 12
    height: 8

  - title: 州・地域別 売上 TOP 10
    name: top_states_sales
    model: thelook_jp
    explore: order_items
    type: looker_bar
    fields: [users.state, order_items.total_sale_price]
    sorts: [order_items.total_sale_price desc]
    limit: 10
    show_view_names: false
    show_value_labels: true
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    listen:
      Date: order_items.created_date
      Age Group: users.age_group
      User Gender: users.gender
      Category: products.category
      State: users.state
    row: 28
    col: 12
    width: 12
    height: 8

  filters:
  - name: Date
    title: 受注日
    type: date_filter
    default_value: 365 days
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
  - name: Age Group
    title: 年齢区分
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: thelook_jp
    explore: order_items
    listens_to_filters: []
    field: users.age_group
  - name: User Gender
    title: 性別
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: thelook_jp
    explore: order_items
    listens_to_filters: []
    field: users.gender
  - name: Category
    title: 商品カテゴリー
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: thelook_jp
    explore: order_items
    listens_to_filters: []
    field: products.category
  - name: State
    title: 州・地域
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: thelook_jp
    explore: order_items
    listens_to_filters: []
    field: users.state
