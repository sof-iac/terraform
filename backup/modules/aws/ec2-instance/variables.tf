variable ec2-instance {
  type = list(object(
    {
      name                   = string
      ami                    = string
      type                   = string
      access-key-name        = string
      vpc-security-group-ids = list(string)
      subnet-id              = string
      env                    = string
    })
  )
}