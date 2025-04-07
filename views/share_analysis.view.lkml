
view: share_analysis {
  derived_table: {
    sql: SELECT
          (EXTRACT(YEAR FROM order_items.created_at  AT TIME ZONE 'Japan')) AS order_items_created_year,
              (FORMAT_TIMESTAMP('%Y-%m', order_items.created_at , 'Japan')) AS order_items_created_month,
          TRIM(products.category)  AS products_category,
          TRIM(products.brand)  AS products_brand,
          TRIM(products.department)  AS products_department,
          CASE WHEN users.country = 'UK' THEN 'United Kingdom'
                 ELSE users.country
                 END
              AS users_country,
          users.state  AS users_state,
          CASE
      WHEN users.age  < 0 THEN '0'
      WHEN users.age  >= 0 AND users.age  < 10 THEN '1'
      WHEN users.age  >= 10 AND users.age  < 20 THEN '2'
      WHEN users.age  >= 20 AND users.age  < 30 THEN '3'
      WHEN users.age  >= 30 AND users.age  < 40 THEN '4'
      WHEN users.age  >= 40 AND users.age  < 50 THEN '5'
      WHEN users.age  >= 50 AND users.age  < 60 THEN '6'
      WHEN users.age  >= 60 AND users.age  < 70 THEN '7'
      WHEN users.age  >= 70 THEN '8'
      ELSE '9'
      END AS users_age_tier__sort_,
          CASE
      WHEN users.age  < 0 THEN 'Below 0'
      WHEN users.age  >= 0 AND users.age  < 10 THEN '0 to 9'
      WHEN users.age  >= 10 AND users.age  < 20 THEN '10 to 19'
      WHEN users.age  >= 20 AND users.age  < 30 THEN '20 to 29'
      WHEN users.age  >= 30 AND users.age  < 40 THEN '30 to 39'
      WHEN users.age  >= 40 AND users.age  < 50 THEN '40 to 49'
      WHEN users.age  >= 50 AND users.age  < 60 THEN '50 to 59'
      WHEN users.age  >= 60 AND users.age  < 70 THEN '60 to 69'
      WHEN users.age  >= 70 THEN '70 or Above'
      ELSE 'Undefined'
      END AS users_age_tier,
          users.gender  AS users_gender,
          COALESCE(SUM(order_items.sale_price), 0) AS order_items_total_sale_price
      FROM looker-private-demo.ecomm.order_items  AS order_items
      FULL OUTER JOIN looker-private-demo.ecomm.inventory_items  AS inventory_items ON inventory_items.id = order_items.inventory_item_id
      LEFT JOIN looker-private-demo.ecomm.users  AS users ON order_items.user_id = users.id
      FULL OUTER JOIN looker-private-demo.ecomm.products  AS products ON products.id = inventory_items.product_id
      GROUP BY
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10
      ORDER BY
          1 DESC;;
  }


  dimension: is_mybrand {
    type: yesno
    sql:  ${TABLE}.products_brand = '{{ _user_attributes['brand'] }}';;
  }

  measure: total_sales_mybrand {
    label: "自社売上"
    type: sum
    sql: ${order_items_total_sale_price} ;;
    filters: [is_mybrand: "yes"]
  }

  measure: total_sales {
    label: "市場全体の売上"
    type: sum
    sql: ${order_items_total_sale_price} ;;
  }

  measure: share_mybrand {
    label: "自社のシェア"
    sql: ${total_sales_mybrand} / nullif(${total_sales}, 0);;
    value_format_name: percent_1
  }



  dimension: order_items_created_year {
    type: number
    sql: ${TABLE}.order_items_created_year ;;
  }

  dimension: order_items_created_month {
    type: string
    sql: ${TABLE}.order_items_created_month ;;
  }

  dimension: products_category {
    type: string
    sql: ${TABLE}.products_category ;;
  }

  # dimension: products_brand {
  #   type: string
  #   sql: ${TABLE}.products_brand ;;
  # }

  dimension: products_department {
    type: string
    sql: ${TABLE}.products_department ;;
  }

  dimension: users_country {
    type: string
    sql: ${TABLE}.users_country ;;
  }

  dimension: users_state {
    type: string
    sql: ${TABLE}.users_state ;;
  }

  dimension: users_age_tier__sort_ {
    type: string
    sql: ${TABLE}.users_age_tier__sort_ ;;
  }

  dimension: users_age_tier {
    type: string
    sql: ${TABLE}.users_age_tier ;;
  }

  dimension: users_gender {
    type: string
    sql: ${TABLE}.users_gender ;;
  }

  dimension: order_items_total_sale_price {
    type: number
    sql: ${TABLE}.order_items_total_sale_price ;;
  }


 }
