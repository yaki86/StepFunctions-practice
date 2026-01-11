def lambda_handler(event,context):
  print("fail...")
  raise Exception("Lambda execution failed intentionally")