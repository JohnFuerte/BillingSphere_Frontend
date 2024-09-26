import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, 'Bad Request');
      break;
    case 401:
      showSnackBar(context, 'Unauthorized');
      break;
    case 403:
      showSnackBar(context, 'Forbidden');
      break;
    case 404:
      showSnackBar(context, 'Not Found');
      break;
    case 500:
      showSnackBar(context, 'Internal Server Error');
      break;
    case 502:
      showSnackBar(context, 'Bad Gateway');
      break;
    case 503:
      showSnackBar(context, 'Service Unavailable');
      break;
    case 504:
      showSnackBar(context, 'Gateway Timeout');
      break;
    default:
      showSnackBar(context, 'Something went wrong');
  }
}
