variable tag {
  type = map(object(
    {
      tag_name             = string
      tag_description      = string
      category_name        = string
      category_description = string
    })
  )
}