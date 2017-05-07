ldap_public:
  ldap_admin_pass_ssha: {SSHA}dPv253zKGzHfcwkJF8oPle8QyZAtXuDo      # Hash obtained using slappasswd with the password defined in private part
  dc:                                                         # Use your domain name here if you don t know what is dc for ldap (cut your domaine name at ".", here sphen.local is cut in two parts)
    - sphen
    - local
