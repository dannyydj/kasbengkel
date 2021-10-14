// import 'dart:async';
// import 'package:http/http.dart' as http;

class GSheetAPI {
  final String baseURL = "https://script.google.com/macros/s/AKfycbwpAlRj2dXa7WuZflKxEJmbcYlFtNkzsizttDFiQJAxjhLByx3QNvIUXVza0AO03Kam/exec";
  String table;

  GSheetAPI({
    required this.table,
  });

  Uri uri (String action, {int id = 0, Map<String,dynamic>? jsonData }){
    String data = "";

    if(action == 'insert'){
      if (jsonData == null) {
        data = "";
        action = 'read';
      }
      data = "&data=${jsonData.toString()}";
    }else if (action == 'update') {
      if (jsonData == null) {
        data = "";
        action = 'read';
      }
      data = "&data=${jsonData.toString()}";
    }else if (action == 'delete'){
      if (id <= 0) {
        data = "";
        action = 'read';
      }
      data = "&data=${jsonData.toString()}";
    }
    String uri = "${baseURL}?action=${action}&table=${table}${data}";
    return Uri.parse(uri);
  } 

}

// class GSheetAPI{
//   static const credentials = r'''
// {
// "type": "service_account",
// "project_id": "stunning-grin-311402",
// "private_key_id": "b7d65c99df34f65bfd10890fb3186b4f07dd96d3",
// "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmX1EwSaYMRyyK\n9RglXrhnXWQuVyHb83u1IWXOW/PQgl89m8B43SmpA9Cc8bccDzVg07s2hV2iuc8p\nzYqAX6c4FN/SdBKRmm6IJBC+AA5fayelyEx7rpOgwb8LEkT+z/DBaAVKIcmr6Yj1\nl/pQWbh7XfHTjqwNWBqoB/jwKHxaaWWP5SRnvxpzFtRzMzj1px25ZZ1SGZm+k1Px\ntPnMY/JB82zHOs2mTqJ6s17HTDQL82CemZjifM7xWPNDaUw0hZe0okh8yJZSE6SN\nLUMbzBg/3rIbowvlTkri7bBSuMOeVun2juSkXDZWhyTeWqkDMozDzPrS+RyEzoxN\no0vXDud3AgMBAAECggEAHdLQVvuczG6lyXMOFQTZwY24O6Za53bKIjoOaeOJ3ULB\nl+WnpwLeSPHqH3gk/t6rDuRlluxpUJZGUJQL099Rtnfnd25fNcKdNcJhTe3spaYr\nwUgajcFJrXONr4pi29qiqcjfyd4srKh8aKoJsQWkUFkS1H2q0emNPbnQIhzfzcT0\ndLPnuYYVXHMcUyrT3zhbqXwxTq+VlSfI1QdFqk8nwUQJCcw9uN2a9sLprpW/sM1I\nlsbeIdGlaupjbpRDUOqzqov9AL/VU8gkhcRUWiy/ysc3qVVU/H6cKGOpzU5LhBxj\n/2EJl8emCjUl2etXVfYOeB+ntBtqLaG2UwF2VrzmoQKBgQDn+FzjMYgw7S7tdpEn\nqM/jhWOQBJogd9TY4+DKPwJt6cXKTQaAfIaMJHTdIA+AFgZX5TfF8PK4d3lVJ9Bd\nKsqhpxZhzPT+wwYUL/fx0N/GMHl8ih1P7svC95xvwXrUh7m0mfWTBoD0RYgEarjC\n4n+Y8wsDZiTiQO14gfTyGdRNawKBgQC3m1wNqraLVLw3Y63bCifKgZZBtmx3V7YR\n1GK6G7OUjDg37FxoPz0Qk3q6Gk5CrehMA2VgvnddPaXG4R391IQ1p78pyW84pVW6\nmM9KLYZiG8tP4UFvOBDa68HR73a/LtkAHBM9YHdUJ/A4cSp1DEW6EMbZ+Ax8T/9S\n+UW5hx3lJQKBgQCBPvVqNLfgItbpwg1AXqNt7m052gaSHpI+QkGGDjNpUD4+6Em+\nHyPMQ6fFaM6aHCtun61CoWxrcU3uL1+9+VCrXvBuj4bVx43Eg7GPT0TPJUUbKc0J\nM1DekZ3c+p1Ye0LyKHIWeCIzd+ZAJ8JH+3ECpDA3tZrJYUmuwiHbHp8WfwKBgHqb\nsJkfys64Qwfp9Is0+OVuK9yt6Ti4xciaP2NwZDdqe5A8smia8jhDg80LC//TCjDY\ng7Za+nK1XCK26cQ7Sh5aanmJHlCBeAInUSWDyR1y2g35qiyPEBJhJQkAFBgPPLGq\nDd8KsCTulqfaSjPnghiCY4fi8NOCyEmsVDdUV05RAoGAGrQb5DT6Rw9kk37iRFii\ndGOsFyi5UftW26LK8+qzsh8o67lsrh9tRBNjyk0sB4YVhi2fsKH5MGlfHRe3wkn6\nE+mstJ3upyYOMzjIbE+Benv6J9jlohyKabRPEB6H5nxfUICeowO1M7arMCl9LfQT\nnExjsRIEyBoVBUpI+Qmk7ZY=\n-----END PRIVATE KEY-----\n",
// "client_email": "kasbengkel@stunning-grin-311402.iam.gserviceaccount.com",
// "client_id": "112025723896872890299",
// "auth_uri": "https://accounts.google.com/o/oauth2/auth",
// "token_uri": "https://oauth2.googleapis.com/token",
// "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
// "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/kasbengkel%40stunning-grin-311402.iam.gserviceaccount.com"
// }
//   ''';
//   static final spreadsheetId = '1vn1K4NqI83QFcoNcOe8xOEORufB9d9OlcghvPFayLp4';
//   static final gsheets = GSheets(credentials);
//   static Worksheet? usersSheet;

//   static Future init() async {
//     final sheet = await gsheets.spreadsheet(spreadsheetId); 
//     usersSheet = await getWorkSheet(sheet, title: "Users");
//   }

//   static Future<Worksheet> getWorkSheet(
//     Spreadsheet spreadsheet,{
//     required String title,
//   }) async {
//     try{
//       return await spreadsheet.addWorksheet(title);
//     }catch (e){
//       print(e);
//       return spreadsheet.worksheetByTitle(title)!;
//     }
//   }

//   static Future insert(List<Map<String,dynamic>> rowList) async{
//     if(usersSheet == null)return;

//     // print(usersSheet!.values);
//     return await usersSheet!.values.map.appendRows(rowList);
//     // print(rowList);
//   }

//   static Future<int> getRowCount () async{
//     if(usersSheet == null)return 0;

//     final lastRow = await usersSheet!.values.lastRow();
//     return int.parse(lastRow!.first);
//   }

// }