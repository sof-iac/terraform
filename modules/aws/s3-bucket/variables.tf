variable bucket {
  type = object(
    {
      name             = string
      object_ownership = string #Valores possíveis: "ObjectWriter", "BucketOwnerPreferred" e "BucketOwnerEnforced" 
      versioning       = bool
      env              = string
    }
  )
}
