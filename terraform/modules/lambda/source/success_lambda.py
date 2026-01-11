def lambda_handler(event,context):
  print("success")

  return{
    "statusCode":200,
    "message": "success",
    "executionId": event.get("executionId", context.aws_request_id),
    "requestId": context.aws_request_id,
  }