import 'package:http/http.dart' as http;
import 'package:httplearning/main.dart';
import 'dart:async';
import 'dart:convert';


class ApiService  {
  static Future<List<dynamic>>  _get(String url)async{
    try{final response = await http.get(url);
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else{
      return null;
    }}
    catch(ex){
      return null;
    }
  }
  static Future<List<dynamic>> getUserList()async{
    return await _get('${URLs.BASE_API_URL}/users');
  }
  static Future<List<dynamic>> getPostList() async{
    return await _get('${URLs.BASE_API_URL}/posts');
  }
  static Future<dynamic> getPosts(int postId) async{
    return await _get('${URLs.BASE_API_URL}/posts/$postId');
  }
static Future<dynamic> getCommentsforPosts(int postId) async{
    return await _get('${URLs.BASE_API_URL}/posts/$postId/comments');
  }
}