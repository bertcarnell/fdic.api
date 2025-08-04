if (Sys.getenv("FDIC_API_KEY") != "") {
  api_key_secret <- Sys.getenv("FDIC_API_KEY")
  print("Envionrment variable retrieved for FDIC_API_KEY")
} else {
  print("Environment variable FDIC_API_KEY not found.")
}
