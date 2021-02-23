import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.purple),
      home: CommonQuotes()
      );

  }
}

class CommonQuotes extends StatefulWidget{
  CommonQuotesState createState() => CommonQuotesState();
}

class CommonQuotesState extends State<CommonQuotes>{

  List quotes = [];

  //overriding initState method and invoking the fetchQuotes method
  @override
    void initState(){
      super.initState();
      this.fetchQuotes();
    }

    //This method is fetching quotes from the url
    fetchQuotes() async{
      var url = "https://type.fit/api/quotes";
      var response = await http.get(url);

      if(response.statusCode == 200){//checking if successful and then decoding json
        var items = json.decode(response.body);
        setState((){
          quotes = items;
        });
      }else{
        setState(() {
           quotes = [];
        });
      }
      
      
    }
 
  
  Widget _buildList(){
    return ListView.builder(//ListView is used to list children
      padding: EdgeInsets.all(8),
      itemCount: quotes.length,
      itemBuilder: (context, index){
         return getCard(quotes[index]);
      }
    );
  }
  //Here a card is returned
  Widget getCard(index){
    var author = index['author'];//the author from the api added to variable
    var quote = index['text'];//the quote from the api added to variable

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Column(children:<Widget> [
            Text(author.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            Text(quote.toString(),style: TextStyle(fontStyle: FontStyle.italic))
          ],)

        ),
        )
    );
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child:Text("Common Quotes"))),
      body: _buildList()
    );
  }
}